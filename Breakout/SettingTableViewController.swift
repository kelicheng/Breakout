//
//  SettingTableViewController.swift
//  Breakout
//
//  Created by ❤ on 1/11/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
//    let settings = Settings()
    @IBOutlet weak var numOfBricksLabel: UILabel!
    @IBOutlet weak var numOfRowsLabel: UILabel!
    @IBOutlet weak var numOfBallsLabel: UILabel!
    
    @IBAction func addBricksPerRow(_ sender: UIStepper) {
        Settings.sharedInstance.numOfBricksPerRow = Int(sender.value)
        numOfBricksLabel.text = String(Int(sender.value))
    }
    @IBAction func addRows(_ sender: UIStepper) {
        Settings.sharedInstance.numOfRows = Int(sender.value)
        numOfRowsLabel.text = String(Int(sender.value))
    }
    @IBAction func changeBallBounciness(_ sender: UISlider) {
        Settings.sharedInstance.ballBounciness = Double(sender.value)
    }
    @IBAction func changeBallNum(_ sender: UIStepper) {
        Settings.sharedInstance.numOfBalls = Int(sender.value)
        numOfBallsLabel.text = String(Int(sender.value))
    }
    @IBAction func enableGravitationPull(_ sender: UISwitch) {
        Settings.sharedInstance.gravitationalPull = sender.isOn
    }
    
    @IBAction func changePaddleLength(_ sender: UISlider) {
        Settings.sharedInstance.paddleLength = Double(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
