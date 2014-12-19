//
//  Timer.swift
//  JustAnIntervalTimer
//
//  Created by McGill, Geoff on 12/16/14.
//  Copyright (c) 2014 McGill, Geoff. All rights reserved.
//

import Foundation

class Timer {
    var name: String
    var date: NSDate
    
    init(name: String, date: NSDate) {
        self.name = name
        self.date = date
    }
}