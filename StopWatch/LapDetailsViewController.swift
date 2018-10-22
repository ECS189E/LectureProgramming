//
//  LapDetailsViewController.swift
//  StopWatch
//
//  Created by Sam King on 10/19/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import UIKit

class LapDetailsViewController: UIViewController {
    @IBOutlet weak var lapNameLabel: UILabel!
    @IBOutlet weak var lapTimeLabel: UILabel!
    
    var lap: LapDisplay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lap = self.lap else {
            return
        }
        
        self.lapTimeLabel.text = String(format: "%0.04f", lap.lapTime)
        self.lapNameLabel.text = "Lap \(lap.lapNumber)"
    }
}
