//
//  AddFoodRecordVC.swift
//  IOCR
//
//  Created by ziming li on 2018-03-14.
//  Copyright © 2018 ziming li. All rights reserved.
//

import UIKit

class AddFoodRecordVC: UIViewController {
    var foodName: String!
    var date: String!
    var time: String!
    var calories: String!
    
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var FoodField: UITextField!
    @IBOutlet weak var CalorieField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FoodField.text = foodName
        DateField.text = getDate()
        loadingIndicator.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard FoodField.text!.isEmpty == false && CalorieField.text!.isEmpty == false else {
            self.displayAlert(message: "Please fill in both food name and calories", title: "Empty Field(s) Found.")
            return
        }
        date = DateField.text![0..<8]
        time = getTime()
        foodName = FoodField.text
        calories = CalorieField.text
        addRecordToCoreData(title: foodName, date: date, time: time, calories: calories)
        successAlert(message: "Calories Recorded", title: "Done!")
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
}
