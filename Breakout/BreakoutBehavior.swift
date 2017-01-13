//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by ❤ on 1/9/17.
//  Copyright © 2017 Keli Cheng. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
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
    
    //    func removeItem(item: UIDynamicItem) {
    //    collisionBehavior.removeAllBoundaries()
    //    collisionBehavior.items.forEach{ collisionBehavior.removeItem($0) }
    //    collisionBehavior.items.forEach{ elasticBehavior.removeItem($0) }
    //        collider.removeItem(item)
    //        itemBehavior.removeItem(item)
    //    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    //    func addWallBarrier(named name: String) {
    //        collider.removeBoundary(withIdentifier: name as NSCopying)
    //        collider.addBoundary(withIdentifier: name as NSCopying, from: CGPoint, to: CGPoint)
    //    }
    func checkState() {
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
        }
        
        if numOfBricks == 0 {
            print("game is over, win")
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        checkState()
        if let idString = identifier as? String {
            if idString.contains("brick") {
                let index = idString.index(idString.startIndex, offsetBy: 5)
                if let brickTag = Int(idString.substring(from: index)) {
                    
                    if let brickView = self.dynamicAnimator?.referenceView?.viewWithTag(brickTag) {
                        //                        brickView.backgroundColor = UIColor.green
                        if brickView.alpha == 1.0 {
                            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                                brickView.alpha = 0.5
                            }, completion: nil)
                            
                        } else if brickView.alpha == 0.5 {
                            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                                brickView.alpha = 0.0
                            }, completion: { _ in // add [unowned self] in
                                self.numOfBricks -= 1
                                brickView.removeFromSuperview()
                                self.collider.removeBoundary(withIdentifier: identifier!)
                                
                            })
                        }
                        
                    }
                    
                }
            }
        }}

}
