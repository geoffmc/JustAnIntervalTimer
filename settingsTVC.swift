//
//  settingsTVC.swift
//  simpleTimer
//
//  Created by McGill, Geoff on 12/12/14.
//  Copyright (c) 2014 McGill, Geoff. All rights reserved.
//

import UIKit

class settingsTVC: UITableViewController {
    
    let kDatePickerTag = 1
    let kTitleKey = "title"
    let kDateKey = "date"
    
    let kTimerCellID = "timerCell"
    let kDatePickerCellID = "datePickerCell"
    
    var data: [Timer] = []
    var dateFormatter = NSDateFormatter()
    
    var datePickerIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        createTimers()
        
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func createTimers() {
        let timer1 = Timer(name: "Date 1", date: NSDate(timeIntervalSince1970: 6324480000))
        let timer2 = Timer(name: "Date 2", date: NSDate(timeIntervalSince1970: 123456789))
        let timer3 = Timer(name: "Date 3", date: NSDate(timeIntervalSince1970: 2349872398))
        let timer4 = Timer(name: "Date 4", date: NSDate())
        let timer5 = Timer(name: "Date 5", date: NSDate(timeIntervalSince1970: 2952972398))
        let timer6 = Timer(name: "Date 6", date: NSDate())
        
        data.append(timer1)
        data.append(timer2)
        data.append(timer3)
        data.append(timer4)
        data.append(timer5)
        data.append(timer6)
    }

    func hasInlineDatePicker() -> Bool {
        if (datePickerIndexPath != nil) {
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
        if (hasInlineDatePicker()) {
            rows++
        }
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (datePickerIndexPath?.row == indexPath.row) {
            let timer = data[indexPath.row-1]
            let cell = tableView.dequeueReusableCellWithIdentifier(kDatePickerCellID, forIndexPath: indexPath) as UITableViewCell
            let targetedDatePicker = cell.viewWithTag(kDatePickerTag) as UIDatePicker
            targetedDatePicker.setDate(timer.date, animated: false)
            return cell
        } else {
            var modelRow = indexPath.row
            if (datePickerIndexPath != nil && datePickerIndexPath?.row <= indexPath.row) {
                modelRow--
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(kTimerCellID, forIndexPath: indexPath) as UITableViewCell
            let timer = data[modelRow] as Timer
            cell.textLabel!.text = timer.name
            cell.detailTextLabel!.text = dateFormatter.stringFromDate(timer.date)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        var newPickerRow = Int()
        var currentPickerRow: Int?
        
        newPickerRow = indexPath.row + 1
        
        if hasInlineDatePicker() {
            currentPickerRow = datePickerIndexPath?.row
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
        datePickerIndexPath = indexPath
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()
    }
    
    func hidePickerCell() {
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([datePickerIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        datePickerIndexPath = nil
        tableView.endUpdates()
    }

    @IBAction func datePickerChanged(sender: UIDatePicker) {
        if (hasInlineDatePicker()) {
            let parentCellIndexPath = NSIndexPath(forRow: datePickerIndexPath!.row-1, inSection: 0)
            let timer = data[parentCellIndexPath.row]
            timer.date = sender.date
            
            if let parentCell = tableView.cellForRowAtIndexPath(parentCellIndexPath) {
                parentCell.detailTextLabel?.text = dateFormatter.stringFromDate(sender.date)
            }
        } else {
            return
        }
    }

}
