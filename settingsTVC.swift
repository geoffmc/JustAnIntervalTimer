//
//  settingsTVC.swift
//  simpleTimer
//
//  Created by McGill, Geoff on 12/12/14.
//  Copyright (c) 2014 McGill, Geoff. All rights reserved.
//

import UIKit

class settingsTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let kTimerCellID = "timerCell"
    let kDatePickerCellID = "datePickerCell"
    let kSecsInMin = 60
    let kSecsInterval = 5
    
    let kTimePickerTag = 2
    var pickerSec = [Int]()
    var pickerMin = [Int]()
    
    var data: [Timer] = []
    var dateFormatter = NSDateFormatter()
    
    var timePickerIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        createTimers()
        setupPicker()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func createTimers() {
        let warmup = Timer(name: "Warmup", time: 20)
        let highInterval = Timer(name: "High Interval", time: 100)
        let lowInterval = Timer(name: "Low Interval", time: 45)
        let cooldown = Timer(name: "Cooldown", time: 155)
        
        data.append(warmup)
        data.append(highInterval)
        data.append(lowInterval)
        data.append(cooldown)
    }
    
    func setupPicker() {
        for (var x=0; x<kSecsInMin; x++) {
            if (x%kSecsInterval == 0) {
                pickerSec.append(x)
            }
            pickerMin.append(x)
        }
    }

    func hasInlinePicker() -> Bool {
        if (timePickerIndexPath != nil) {
            return true
        } else {
            return false
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = data.count
        if (hasInlinePicker()) {
            rows++
        }
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (timePickerIndexPath?.row == indexPath.row) {
            let timer = data[indexPath.row-1]
            let cell = tableView.dequeueReusableCellWithIdentifier(kDatePickerCellID, forIndexPath: indexPath) as UITableViewCell
            
            let targetedTimePicker = cell.viewWithTag(kTimePickerTag) as UIPickerView
            targetedTimePicker.delegate = self
            targetedTimePicker.dataSource = self
            targetedTimePicker.selectRow(timer.time / kSecsInMin, inComponent: 0, animated: false)
            targetedTimePicker.selectRow(timer.time % kSecsInMin / kSecsInterval, inComponent: 1, animated: false)
            
            return cell
            
        } else {
            var modelRow = indexPath.row
            if (timePickerIndexPath != nil && timePickerIndexPath?.row <= indexPath.row) {
                modelRow--
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(kTimerCellID, forIndexPath: indexPath) as UITableViewCell
            let timer = data[modelRow] as Timer
            cell.textLabel!.text = timer.name
            cell.detailTextLabel!.text = formatSecondsAsString(timer.time)
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        var newPickerRow = Int()
        var currentPickerRow: Int?
        
        newPickerRow = indexPath.row + 1
        
        if hasInlinePicker() {
            currentPickerRow = timePickerIndexPath?.row
            if (newPickerRow > currentPickerRow) {
                newPickerRow -= 1
            }
            hidePickerCell()
            if (newPickerRow == currentPickerRow) {
                return
            }
        }
        
        let pickerIndexPath = NSIndexPath(forRow: newPickerRow, inSection: 0)
        displayInlinePickerAtIndexPath(pickerIndexPath)
    }
    
    func displayInlinePickerAtIndexPath(indexPath: NSIndexPath) {
        tableView.beginUpdates()
        timePickerIndexPath = indexPath
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()
    }
    
    func hidePickerCell() {
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([timePickerIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        timePickerIndexPath = nil
        tableView.endUpdates()
    }
    
    func formatSecondsAsString(time: Int) -> String {
        var mins = time / kSecsInMin
        var secs = time % kSecsInMin
        
        var timeString = "\(mins):\(secs)"
        
        if (mins < 10 && secs < 10) {
            timeString = "0\(mins):0\(secs)"
        } else if (mins < 10) {
            timeString = "0\(mins):\(secs)"
        } else if (secs < 10) {
            timeString = "\(mins):0\(secs)"
        }
        
        return timeString
    }
    
    // MARK: - UIPickerView Delegate and Data Source Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (component == 0) ? pickerMin.count * kSecsInterval : pickerSec.count * kSecsInterval
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return (component == 0) ? "\(pickerMin[row % pickerMin.count])" : "\(pickerSec[row % pickerSec.count])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (hasInlinePicker()) {
            let parentCellIndexPath = NSIndexPath(forRow: timePickerIndexPath!.row-1, inSection: 0)
            let timer = data[parentCellIndexPath.row]
            
            let mins = pickerMin[pickerView.selectedRowInComponent(0) % pickerMin.count]
            let secs = pickerSec[pickerView.selectedRowInComponent(1) % pickerSec.count]
            
            timer.time = mins * kSecsInMin + secs
            
            if let parentCell = tableView.cellForRowAtIndexPath(parentCellIndexPath) {
                parentCell.detailTextLabel?.text = formatSecondsAsString(timer.time)
            }
        }
        
    }
    

}
