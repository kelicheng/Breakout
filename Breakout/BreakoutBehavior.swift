//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by ❤ on 1/9/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    var breakoutBehaviorDelegate: BreakoutBehaviorDelegate?
    let gravity = UIGravityBehavior()
    lazy var collider: UICollisionBehavior = {
        // configure
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = false
        collider.collisionDelegate = self
        //        collider.collisionMode = UICollisionBehaviorMode.boundaries
        return collider
    }()
    
    private let itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = true
        itemBehavior.elasticity = CGFloat(Settings.sharedInstance.ballBounciness)
        itemBehavior.friction = 0
        itemBehavior.resistance = 0
        return itemBehavior
    }()
    
    var numOfBricks = 0
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    func addItem(item: UIDynamicItem) {
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }

    func removeItems() {
        collider.removeAllBoundaries()
        collider.items.forEach{ collider.removeItem($0) }
        collider.items.forEach{ itemBehavior.removeItem($0) }
        numOfBricks = 0
    }
    
 
    func checkState() {
//        TODO: fixing problem of ball disappears 
        print("checking state")
        var allBallsFallOff = true
        if let view = dynamicAnimator?.referenceView as? BreakoutView {
            for ball in view.balls {
                if ball!.center.y <= view.bounds.maxY {
                    allBallsFallOff = false
                    break
                }
            }
            
        }
        
        if allBallsFallOff {
            print("game is over, lost")
            if let delegate = breakoutBehaviorDelegate {
                delegate.gameOver(playerWon: false)
            }
        }
        
        else if numOfBricks == 0 {
            print("game is over, win")
            if let delegate = breakoutBehaviorDelegate {
                delegate.gameOver(playerWon: true)
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        checkState()
        if let idString = identifier as? String {
            if idString.contains("brick") {
                let index = idString.index(idString.startIndex, offsetBy: 5)
                if let brickTag = Int(idString.substring(from: index)) {
                    if let view = dynamicAnimator?.referenceView as? BreakoutView {
                        if let brickView = view.viewWithTag(brickTag) {
                            //                        brickView.backgroundColor = UIColor.green
                            if brickView.alpha == 1.0 {
                                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                                    brickView.alpha = 0.5
                                }, completion: nil)
                                
                            } else if brickView.alpha == 0.5 {
                                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                                    brickView.alpha = 0.0
                                }, completion: { [unowned self] completed in 
                                    self.numOfBricks -= 1
                                    brickView.removeFromSuperview()
                                    self.collider.removeBoundary(withIdentifier: identifier!)
                                    
                                })
                            }
                            view.score += 10
                            if let delegate = breakoutBehaviorDelegate {
                                delegate.updateScore()
                            }
                            
                        }
                    }
                    
                }
            }
        }}
    
}
