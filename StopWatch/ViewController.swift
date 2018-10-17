//
//  ViewController.swift
//  StopWatch
//
//  Created by Sam King on 10/1/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateTime, UITableViewDataSource, UITableViewDelegate, SettingsUpdateDelegate {
    func settingsUpdated(turbo: Bool) {
        // normally we'd update the state to relfect the changes, but in the interest
        // of time we'll skip it in our demo
        // self.timer.turbo = turbo
        print("turbo is \(turbo)")
        self.dismiss(animated: true)
    }
    
    func cancelled() {
        // don't do anything, just close the viewcontroller
        self.dismiss(animated: true)
    }
    
    
    func lapsUpdated(_ laps: [TimeInterval]) {
        var displayLaps: [LapDisplay] = []
        for (index, lap) in laps.reversed().enumerated() {
            displayLaps.append(LapDisplay(lapNumber: laps.count - index, lapTime: lap))
        }
        self.laps = displayLaps
        self.tableView.reloadData()
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startClick() {
        self.toggleButton(withTitles: ("Start", "Stop"), on: self.startButton)
        self.timer.startTimer()
    }
    
    @IBAction func lapButtonPressed() {
        self.timer.lap()
    }
    
    @IBAction func settingsPress() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
        // set the delegate by setting a variable on the viewcontroller
        viewController.delegate = self
        self.present(viewController, animated: true)
        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
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

