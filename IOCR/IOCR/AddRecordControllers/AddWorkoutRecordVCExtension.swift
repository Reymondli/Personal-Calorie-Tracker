//
//  AddWorkoutRecordVCExtension.swift
//  IOCR
//
//  Created by ziming li on 2018-03-14.
//  Copyright © 2018 ziming li. All rights reserved.
//

import UIKit

extension AddWorkoutRecordVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return eventList.count
        } else {
            return hourList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            let content = eventList[row]
            return content
        } else {
            let content = hourList[row]
            return content
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            WorkoutField.text = eventList[row]
        } else {
            HoursField.text = hourList[row]
        }
    }
    
}

extension AddWorkoutRecordVC {
    func createWorkoutEventPicker() {
        let eventPicker = UIPickerView()
        eventPicker.delegate = self
        eventPicker.tag = 1
        WorkoutField.inputView = eventPicker
        eventPicker.backgroundColor = .white
    }
    
    func createTimePicker() {
        let timePicker = UIPickerView()
        timePicker.delegate = self
        timePicker.tag = 2
        HoursField.inputView = timePicker
        timePicker.backgroundColor = .white
    }
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .blue
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddWorkoutRecordVC.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        WorkoutField.inputAccessoryView = toolBar
        HoursField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

