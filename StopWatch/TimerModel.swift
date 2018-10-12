//
//  TimerModel.swift
//  StopWatch
//
//  Created by Sam King on 10/8/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import Foundation

protocol UpdateTime {
    func timeUpdated(_ interval: TimeInterval)
}

class TimerModel {
    var updateDelegate: UpdateTime?
    var startTime: Date?
    var timer: Timer?
    
    init() {
    }
    
    func timeSinceStart() -> TimeInterval {
        guard let startTime = self.startTime else {
            print("something is wrong")
            return 0.0
        }
        
        return Date().timeIntervalSince(startTime)
    }
    
    func startTimer() -> Void {
        self.startTime = Date()
        // don't worry about runloop details, we'll talk about it later
        let timer = Timer(timeInterval: 0.01, repeats: true, block: { (_) in
            let elapsedTime = self.timeSinceStart()
            self.updateDelegate.map { $0.timeUpdated(elapsedTime) }
        })
        self.timer = timer
        RunLoop.current.add(timer, forMode: .default)
    }
}
