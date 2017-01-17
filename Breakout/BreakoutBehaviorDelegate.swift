//
//  BreakoutBehaviorDelegate.swift
//  Breakout
//
//  Created by ❤ on 1/16/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import Foundation
protocol BreakoutBehaviorDelegate {
    func gameOver(playerWon: Bool)
    func updateScore()
}
