//
//  ViewController.swift
//  StopWatch
//
//  Created by Sam King on 10/1/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateTime, UITableViewDelegate, UITableViewDataSource {
    struct LapData {
        let number: Int
        let time: Double
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lap") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "lap")
        let lap = self.laps[indexPath.row]
        cell.textLabel?.text = "Lap \(lap.number)"
        cell.detailTextLabel?.text = String(format: "%0.02f", lap.time)
        
        return cell
    }
    
    func lapsUpdated(_ laps: [TimeInterval]) {
        let count = laps.count
        self.laps = []
        for (idx, lap) in laps.enumerated() {
            self.laps.append(LapData(number: (count - idx), time: lap))
        }
        self.tableView.reloadData()
    }
    
    func timeUpdated(_ interval: TimeInterval) {
        self.elapsedTimeLabel.text = String(format: "%0.02f", interval)
    }
    

    let timer = TimerModel()
    var laps: [LapData] = []
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func lapClick() {
        self.timer.lap()
    }
    
    @IBAction func startClick() {
        if self.startButton.currentTitle == "Start" {
            self.timer.start()
        } else {
            self.timer.stop()
        }
        self.toggleButton(withTitles: ("Start", "Stop"), on: self.startButton)
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

