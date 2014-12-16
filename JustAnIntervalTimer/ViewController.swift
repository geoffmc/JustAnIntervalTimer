//
//  ViewController.swift
//  JustAnIntervalTimer
//
//  Created by McGill, Geoff on 12/16/14.
//  Copyright (c) 2014 McGill, Geoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: ("timerFired"), userInfo: nil, repeats: true)
        
    }
    
    func timerFired() {
        println("Timer fired!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

