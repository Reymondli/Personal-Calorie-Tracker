//
//  AddWorkoutRecordVC.swift
//  IOCR
//
//  Created by ziming li on 2018-03-14.
//  Copyright © 2018 ziming li. All rights reserved.
//

import UIKit

class AddWorkoutRecordVC: UIViewController {
    var workoutName: String!
    var date: String!
    var time: String!
    var calories: String!
    var defaultCalories: String!
    
    // MARK: - Provide event list and calories for each event per hour.
    let eventList = ["","badminton","baseball","climbing","gym","soccer","swimming"]
    let eventCalorie = [
        "badminton": 272,
        "baseball": 364,
        "climbing": 600,
        "gym": 400,
        "soccer": 520,
        "swimming": 500
    ]
    let hourList = ["","1","2","3","4","5","6","7","8"]

    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var WorkoutField: UITextField!
    @IBOutlet weak var HoursField: UITextField!
    @IBOutlet weak var CalorieField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalorieField.delegate = self
        createWorkoutEventPicker()
        createTimePicker()
        createToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        WorkoutField.text = workoutName
        CalorieField.text = "(Optional)"
        DateField.text = getDate()
        loadingIndicator.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard WorkoutField.text!.isEmpty == false && HoursField.text!.isEmpty == false else {
            self.displayAlert(message: "Please fill in both workout event and hours", title: "Empty Field(s) Found.")
            return
        }
        
        date = DateField.text![0..<8]
        time = getTime()
        workoutName = WorkoutField.text
        calories = setCalories()
        addRecordToCoreData(title: workoutName, date: date, time: time, calories: calories)
        successAlert(message: "Calories Recorded", title: "Done!")
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    func setCalories() -> String {
        if self.CalorieField.text!.isEmpty == true || self.CalorieField.text! == "(Optional)" {
            defaultCalories = "-" + String(eventCalorie[workoutName]!*Int(HoursField.text!)!)
            return defaultCalories!
        } else {
            return "-" + CalorieField.text!
        }
    }
    
}
