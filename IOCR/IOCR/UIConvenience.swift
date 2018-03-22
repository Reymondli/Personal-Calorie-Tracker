//
//  UIConvenience.swift
//  IOCR
//
//  Created by ziming li on 2018-03-14.
//  Copyright © 2018 ziming li. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Error Alert
    func displayAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Success Alert
    func successAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) in
            // alert.dismiss(animated: true, completion: nil)
            // self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Get Current Time and Date
    func getDate() -> String! {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss"
        let result = formatter.string(from: Date())
        return result
    }
    
    func getTime() -> String! {
        let calendar = Calendar.current
        let hour = String(calendar.component(.hour, from: Date()))
        let minutes = calendar.component(.minute, from: Date())
        let str_minutes = (minutes >= 10) ? String(minutes): "0"+String(minutes)
        return hour + ": " + str_minutes
    }
    
    // MARK: - Add recorded events into CoreData
    func addRecordToCoreData(title: String, date: String, time: String, calories: String) {
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("record.plist")
        // Load Current Record List
        var recordList = loadRecords(dataFilePath: dataFilePath)
        // Append new event into list
        let newRecord = Record()
        newRecord.title = title
        newRecord.date = date
        newRecord.time = time
        newRecord.calories = calories
        recordList.append(newRecord)
        // Update and save the updated list
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(recordList)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding Record.plist file, \(error)")
        }
    }
    
    func loadRecords(dataFilePath: URL!)-> [Record] {
        var recordList = [Record]()
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                recordList = try decoder.decode([Record].self, from: data)
            } catch {
                print("Errors decoding Record.plist file, \(error)")
            }
        }
        return recordList
    }

}

extension UIViewController: UITextFieldDelegate {
    // ----------Keyboard Methods---------- //
    // MARK: Keyboard Adjustments - Show
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
    }
    
    // MARK: Keyboard Adjustments - Hide
    @objc func keyboardWillHide(_ notification:Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Dismiss the keyboard after pressing "Enter"
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
