//
//  ViewController.swift
//  StopWatch
//
//  Created by Sam King on 10/1/18.
//  Copyright © 2018 Sam King. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startClick() {
        self.toggleButton(withTitles: ("Start", "Stop"), on: self.startButton)
    }
    
    func toggleButton(withTitles titles: (String, String), on button: UIButton) {
        let title = button.currentTitle == titles.0 ? titles.1 : titles.0
        button.setTitle(title, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

