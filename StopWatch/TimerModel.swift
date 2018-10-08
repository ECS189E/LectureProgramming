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
    func lapsUpdated(_ laps: [TimeInterval])
}

class TimerModel {
    var updateDelegate: UpdateTime?
    var startTime: Date?
    var stopTime: Date?
    var lastLap: Date?
    var timer: Timer?
    var laps: [TimeInterval]
    
    init() {
        self.laps = []
    }
    
    func timeSinceStart(_ date: Date = Date()) -> TimeInterval {
        guard let startTime = self.startTime else {
            print("something is wrong")
            return 0.0
        }
        
        return date.timeIntervalSince(startTime)
    }
    
    func stop() {
        let stopTime = Date()
        self.stopTime = stopTime
        self.timer.map { $0.invalidate() }
        self.timer = nil
        self.updateDelegate.map { $0.timeUpdated(self.timeSinceStart(stopTime)) }
    }
    
    func lap() {
        guard let startTime = self.startTime else {
            print("set lap when not running, ignore")
            return
        }
        
        let now = Date()
        let lapTime = now.timeIntervalSince(self.lastLap ?? startTime)
        self.laps.insert(lapTime, at: 0)
        self.lastLap = now
        self.updateDelegate.map { $0.lapsUpdated(self.laps) }
    }
    
    func start() {
        self.startTime = Date()
        let timer = Timer(timeInterval: 0.01, repeats: true, block: { (_) in
            let elapsedTime = self.timeSinceStart()
            self.updateDelegate.map { $0.timeUpdated(elapsedTime) }
        })
        RunLoop.current.add(timer, forMode: .default)
        self.timer = timer
        self.laps = []
        
        self.updateDelegate.map { $0.lapsUpdated(self.laps) }
    }
}
