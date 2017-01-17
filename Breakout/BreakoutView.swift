//
//  BreakoutView.swift
//  Breakout
//
//  Created by ❤ on 1/8/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import UIKit

class BreakoutView: UIView {
    var score = 0
    
    // ANIMATION
    let breakoutBehavior = BreakoutBehavior()
    lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        return animator
    }()
    
    var animating: Bool = false {
        didSet {
            if animating {
                breakoutBehavior.numOfBricks = numOfRows * bricksPerRow
                animator.addBehavior(breakoutBehavior)
            } else {
                animator.removeBehavior(breakoutBehavior)
            }
        }
    }
    
    // BRICKS
    var bricksPerRow = 5
    var numOfRows = 4
    private var brickSize: CGSize {
        let size = (bounds.size.width - brickSpace * CGFloat(bricksPerRow - 1)) / CGFloat(bricksPerRow)
        return CGSize(width: size, height: size/2)
    }
    //    private lazy var brickSpace = CGFloat(self.brickSize.width/20)
    private var brickSpace = CGFloat(5)
    
    func setBricks() {
        for row in 1...numOfRows {
            for usedBricks in 0...bricksPerRow-1 {
                let xOffset = (brickSize.width + brickSpace) * CGFloat(usedBricks)
                let yOffset = (brickSize.height + brickSpace) * CGFloat(row-1)
                
                var frame = CGRect(origin: CGPoint.zero, size: brickSize)
                frame.origin.x = xOffset
                frame.origin.y = yOffset
                
                let brick = UIView(frame: frame)
                brick.backgroundColor = UIColor.brown
                //                brick.layer.borderColor = UIColor.black.cgColor
                //                brick.layer.borderWidth = 1.0
                let tagString = String(row)+String(usedBricks+1)
                brick.tag = Int(tagString)!
                
                addSubview(brick)
                //                breakoutBehavior.addItem(item: brick)
                let path = UIBezierPath(rect: brick.frame)
                breakoutBehavior.addBarrier(path: path, named: "brick"+tagString)
            }
        }
        
    }
    
    // PADDLE
    var paddle: UIView?
    var paddleLength = Settings.sharedInstance.paddleLength
    
    func setPaddle() {
        var frame = CGRect(origin: CGPoint.zero, size: CGSize(width: paddleLength, height: 10))
        frame.origin.y = bounds.size.height-CGFloat(10)
        paddle = UIView(frame: frame)
        paddle!.backgroundColor = UIColor.darkGray
        paddle!.layer.cornerRadius = 5
        //        paddle.layer.masksToBounds = true
        
        addSubview(paddle!)
        //        breakoutBehavior.addItem(item: paddle!)
        let path = UIBezierPath(rect: paddle!.frame)
        breakoutBehavior.addBarrier(path: path, named: "paddleBarrier")
    }
    
    func movePaddle(_ recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .changed, .ended:
            if let paddle = self.paddle {
                paddle.frame.origin.x = gesturePoint.x-CGFloat(paddleLength/2)
                
                // update bounday with current position
                let path = UIBezierPath(rect: paddle.frame)
                breakoutBehavior.addBarrier(path: path, named: "paddleBarrier")
                
            } else {
                print("paddle is nil")
            }
            
        default:
            break
        }
    }
    
    // BOUNCING BALL
    
    var balls: [UIView?] = []
    
    func setBall() {
        var frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        frame.origin.x = CGFloat(paddleLength/2-15)
        frame.origin.y = bounds.size.height-CGFloat(40)
        let ball = UIView(frame: frame)
        ball.backgroundColor = UIColor.lightGray
        //        let image = UIImage(named: "Pokeball-48.png")
        //        image?.draw(in: frame)
        //        ball!.backgroundColor = UIColor(patternImage: image!)
        ball.layer.cornerRadius = 15
        
        addSubview(ball)
        balls.append(ball)
        
        //        breakoutBehavior.gravity.addItem(ball!)
        breakoutBehavior.addItem(item: ball)
        
        //        pushBall(ball: ball!)
        
    }
    
    // tap to push ball in a randome direction
    func pushBall(_ recognizer: UITapGestureRecognizer) {
        breakoutBehavior.checkState()
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        switch recognizer.state {
        case .changed, .ended:
            for ball in balls {
                let push = UIPushBehavior(items: [ball!], mode: UIPushBehaviorMode.instantaneous)
                let random = arc4random_uniform(180)
                let angle = M_PI*180/Double(random)
                push.setAngle( CGFloat(angle) , magnitude: 0.5)
                push.addItem(ball!)
                animator.addBehavior(push)
                // remove with push's action
                push.action = {
                    push.removeItem(ball!)
                    self.animator.removeBehavior(push)
                }
                
                
            }
        default:
            break
        }
        
    }
    
    // WALLBarrier
    func setWallBarrier() {
        let pt1 = CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.height)
        let pt2 = bounds.origin
        let pt3 = CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y)
        let pt4 = CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height)
        breakoutBehavior.collider.addBoundary(withIdentifier: "LeftWall" as NSCopying, from: pt1, to: pt2)
        breakoutBehavior.collider.addBoundary(withIdentifier: "TopWall" as NSCopying, from: pt2, to: pt3)
        breakoutBehavior.collider.addBoundary(withIdentifier: "RightWall" as NSCopying, from: pt3, to: pt4)
    }
    
    // GAME OVER IF ALL BRICKS ARE ELIMINATED OR BALL FALL OFF
    
    
}
