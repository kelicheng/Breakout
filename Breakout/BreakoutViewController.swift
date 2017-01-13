//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by ❤ on 1/8/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController {
    
    @IBOutlet weak var gameView: BreakoutView! {
        didSet {
            // add gesture recognizers
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(gameView.movePaddle(_:))))
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: #selector(gameView.pushBall(_:))))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGame()
        startGame()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func setGame() {
        gameView.bricksPerRow = Settings.sharedInstance.numOfBricksPerRow
        gameView.numOfRows = Settings.sharedInstance.numOfRows
        gameView.paddleLength = Settings.sharedInstance.paddleLength
      
//        var ballBounciness = 1.0
//        var gravitationalPull = false
        
        gameView.setBricks()
        gameView.setPaddle()
        var numOfBalls = 1
        while numOfBalls <= Settings.sharedInstance.numOfBalls{
            gameView.setBall()
            numOfBalls += 1
        }
        
        gameView.setWallBarrier()
        
    }
    
    func startGame() {
        gameView.animating = true
    }
    
    func endGame() {
        gameView.animating = false
    }
    
}
