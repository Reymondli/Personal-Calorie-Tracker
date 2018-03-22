//
//  FoodViewController.swift
//  IOCR
//
//  Created by ziming li on 2018-03-14.
//  Copyright © 2018 ziming li. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreML

class FoodViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var currentFood: String?
    
    @IBOutlet weak var FoodButton: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        // Start Camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        // Use "try?" for any potential throwing error (e.g. no camera on device)
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        // Access camera frame layer
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let captureSession = AVCaptureSession()
        captureSession.stopRunning()
        print("Session Stopped")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // print("Frame Captured!", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        guard let model = try? VNCoreMLModel(for: food101ml().model) else {
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            // check the err
            // print(finishedReq.results)
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {
                return
            }
            
            guard let firstObservation = results.first else {
                return
            }
            DispatchQueue.main.async {
                self.FoodButton.setTitle(firstObservation.identifier, for: .normal)
                self.currentFood = firstObservation.identifier
            }
            // print(firstObservation.identifier, firstObservation.confidence)
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
    
    @IBAction func foodDetected(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "addfoodcalorie") as! AddFoodRecordVC
        controller.foodName = self.currentFood
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

