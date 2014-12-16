//
//  timerVC.swift
//  simpleTimer
//
//  Created by McGill, Geoff on 12/12/14.
//  Copyright (c) 2014 McGill, Geoff. All rights reserved.
//

import UIKit

class timerVC: UIViewController {
    
    var initialTimerLength = 30
    
    var timerLength = Int()
    var timerRunning = false
    var timer = NSTimer()

    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getSavedSettings()
        timerLength = initialTimerLength
        updateUI()
    }
    
    func startTimer() {
        if (!timerRunning) {
            timerRunning = true
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if (timerRunning) {
            timer.invalidate()
            timerRunning = false
        }
    }
    
    func resetTimer() {
        stopTimer()
        timerLength = initialTimerLength
        updateUI()
    }
    
    func updateTimer() {
        timerLength -= 1
        updateUI()
    }
    
    func updateUI() {
        timerLabel.text = "\(timerLength)"
    }
    
    func getSavedSettings() {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let intervalTimerLength = defaults.objectForKey("intervalTimerLength") as? Int {
            initialTimerLength = intervalTimerLength
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func pressedStart(sender: UIButton) {
        println("pressed start")
        startTimer()
    }
    @IBAction func pressedStop(sender: UIButton) {
        println("pressed stop")
        stopTimer()
    }
    @IBAction func pressedReset(sender: UIButton) {
        println("pressed reset")
        resetTimer()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
