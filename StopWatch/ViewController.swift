//
//  ViewController.swift
//  StopWatch
//
//  Created by Sam King on 10/1/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateTime, UITableViewDataSource, UITableViewDelegate {
    
    func lapsUpdated(_ laps: [TimeInterval]) {
        var displayLaps: [LapDisplay] = []
        for (index, lap) in laps.reversed().enumerated() {
            displayLaps.append(LapDisplay(lapNumber: laps.count - index, lapTime: lap))
        }
        self.laps = displayLaps
    }
    

    struct LapDisplay {
        let lapNumber: Int
        let lapTime: TimeInterval
    }
    
    @IBOutlet weak var timeDisplayLabel: UILabel!
    var laps: [LapDisplay]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // by default there is one section for each tableview
        return self.laps?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let laps = self.laps else {
            return UITableViewCell()
        }
        
        let lap = laps[indexPath.row]
        
        // the identifier is like the type of the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "lapCell")
        
        // IMPORTANT: make sure to set all fields!
        cell.textLabel?.text = "Lap \(lap.lapNumber)"
        cell.detailTextLabel?.text = String(format: "%0.02f", lap.lapTime)
        
        return cell
    }
    
    func timeUpdated(_ interval: TimeInterval) {
        self.timeDisplayLabel.text = String(format: "%0.02f", interval)
    }
    

    let timer = TimerModel()
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startClick() {
        self.toggleButton(withTitles: ("Start", "Stop"), on: self.startButton)
        self.timer.startTimer()
    }
    
    @IBAction func lapButtonPressed() {
        self.timer.lap()
    }
    
    func toggleButton(withTitles titles: (String, String), on button: UIButton) {
        let title = button.currentTitle == titles.0 ? titles.1 : titles.0
        button.setTitle(title, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer.updateDelegate = self
    }


}

