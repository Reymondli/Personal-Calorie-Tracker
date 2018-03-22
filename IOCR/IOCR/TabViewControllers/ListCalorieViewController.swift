//
//  ListCalorieViewController.swift
//  IOCR
//
//  Created by ziming li on 2018-03-14.
//  Copyright © 2018 ziming li. All rights reserved.
//

import UIKit

class ListCalorieViewController: UITableViewController {
    
    var recordList = [Record]()
    
    // MARK: - File Data Path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("record.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecords()
        tableView.reloadData()
    }
    
    // MARK: - Add TableView Datasource Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = recordList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath)
        cell.textLabel!.text = record.title + ": " + record.calories
        cell.detailTextLabel!.text = record.date + " at " + record.time
        return cell
    }
    
    // MARK: - Add TableView Delegate Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  .delete {
            recordList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveRecords()
        }
    }
    
    func saveRecords() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(recordList)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding Record.plist file, \(error)")
        }
    }
    
    func loadRecords() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                recordList = try decoder.decode([Record].self, from: data)
            } catch {
                print("Errors decoding Record.plist file, \(error)")
            }
        }
    }
}
