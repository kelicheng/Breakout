//
//  Settings.swift
//  Breakout
//
//  Created by ❤ on 1/12/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import Foundation
class Settings {
    static let sharedInstance = Settings()
    
    var numOfBricksPerRow = 5
    var numOfRows = 4
    var ballBounciness = 1.0
    var numOfBalls = 1
    var gravitationalPull = false
    var paddleLength = 100.0
    
    func test() {
        print(numOfBricksPerRow)
    }
}
