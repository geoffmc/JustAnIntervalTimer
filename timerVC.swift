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
    
    let kWarmupDefault = 10
    let kHighIntDefault = 60
    let kLowIntDefault = 10
    let kCooldownDefault = 30
    let kRoundsDefault = 5
    
    var timerLength = Int()
    var timerRunning = false
    var timer = NSTimer()
    
    var warmupTimer: Timer
    var highIntTimer: Timer
    var lowIntTimer: Timer
    var cooldownTimer: Timer
    var rounds: Int
    
    var pickerSec = [Int]()
    var pickerMin = [Int]()

    @IBOutlet weak var timerLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let warmup = (defaults.objectForKey("warmup") != nil) ? defaults.objectForKey("warmup") as? Int : kWarmupDefault
        let highInt = (defaults.objectForKey("highInt") != nil) ? defaults.objectForKey("highInt") as? Int : kHighIntDefault
        let lowInt = (defaults.objectForKey("lowInt") != nil) ? defaults.objectForKey("lowInt") as? Int : kLowIntDefault
        let cooldown = (defaults.objectForKey("cooldown") != nil) ? defaults.objectForKey("cooldown") as? Int : kCooldownDefault
        let rounds = (defaults.objectForKey("rounds") != nil) ? defaults.objectForKey("rounds") as? Int : kRoundsDefault
        
        self.warmupTimer = Timer(name: "Warmup", time: warmup!)
        self.highIntTimer = Timer(name: "High Interval", time: highInt!)
        self.lowIntTimer = Timer(name: "Low Interval", time: lowInt!)
        self.cooldownTimer = Timer(name: "Cooldown", time: cooldown!)
        self.rounds = rounds!
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getTimerSettings()
        timerLength = initialTimerLength
        updateUI()
    }
    
    func getTimerSettings() {
        
        
        
        
        let warmup = Timer(name: "Warmup", time: 20)
        let highInterval = Timer(name: "High Interval", time: 100)
        let lowInterval = Timer(name: "Low Interval", time: 45)
        let cooldown = Timer(name: "Cooldown", time: 155)
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
