//
//  SettingsViewController.swift
//  StopWatch
//
//  Created by Sam King on 10/17/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import UIKit

protocol SettingsUpdateDelegate {
    func settingsUpdated(turbo: Bool)
    func cancelled()
}

class SettingsViewController: UIViewController {

    var delegate: SettingsUpdateDelegate?
    
    @IBAction func cancel() {
        self.delegate?.cancelled()
    }
    @IBAction func done() {
        // update state
        self.delegate?.settingsUpdated(turbo: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print("hey I'm loaded")
    }

}
