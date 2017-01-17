//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by ❤ on 1/8/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, BreakoutBehaviorDelegate{
    
    @IBOutlet weak var gameView: BreakoutView! {
        didSet {
            // add gesture recognizers
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(gameView.movePaddle(_:))))
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: #selector(gameView.pushBall(_:))))
        }
    }
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        clear()
        setGame()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGame()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.breakoutBehavior.breakoutBehaviorDelegate = self
    }
    
    func clear() {
        gameView.breakoutBehavior.removeItems()
        //        gameView.animating = false
        gameView.subviews.forEach{ $0.removeFromSuperview() }
        
    }
    
    private func setGame() {
        // set score labels
        if let score = UserDefaults.standard.value(forKey: "highestScore") {
            highestScore = score as! Int
            highestScoreLabel.text = String(describing: score)
        }
        gameView.score = 0
        updateScore()
        
        // configure gameView
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
        gameView.animating = true
        
    }
    
    var highestScore = 0
    func updateScore() {
        currentScoreLabel.text = String(gameView.score)
        if gameView.score > highestScore {
            highestScore = gameView.score
            print(highestScore)
            UserDefaults.standard.setValue(highestScore, forKey: "highestScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func gameOver(playerWon: Bool) {
        if playerWon {
            let alert = UIAlertController(title: "Won!", message: "Score: " + String(gameView.score), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [unowned self] _ in
                self.clear()
                self.setGame()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Lost", message: "Score: " + String(gameView.score), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [unowned self] _ in
                self.clear()
                self.setGame()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
