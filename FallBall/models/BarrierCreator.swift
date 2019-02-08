//
//  BarrierCreator.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit



class BarrierCreator {
    
    static private let DEFAULT_HORIZONTAL_DISTANCE: CGFloat = 10
    static private let DEFAULT_HORIZONTAL_DURATION: TimeInterval = 1
    static private let DEFAULT_VERTICAL_DISTANCE: CGFloat = -300
    static private let DEFAULT_VERTICAL_DURATION: TimeInterval = 2
    static private let DEFAULT_BARRIER_COLOR: SKColor = SKColor.white
    
    private var barriers: [SKShapeNode] = []
    var delegate: BarrierCreatorDelegate?
    
    func randomBarrier() -> Barrier {
        return Barrier.init(velocity: 3)
    }
    
    func dequeueBarrier(withRect barrierRect: CGRect) -> SKShapeNode? {
        var newBarrierNode: SKShapeNode?
        
        if let firstBarrier = self.barriers.first {
            if let barrierIsNotFree = delegate?.responsible(by: self).intersects(firstBarrier),
                !barrierIsNotFree {
                newBarrierNode = setupBarrier(withRect: barrierRect, andBarrier: firstBarrier)
                
                self.barriers.remove(at: 0)
                self.barriers.append(firstBarrier)
            } else {
                newBarrierNode = setupBarrier(withRect: barrierRect)
                self.barriers.append(newBarrierNode!)
            }
        } else {
            newBarrierNode = setupBarrier(withRect: barrierRect)
            self.barriers.append(newBarrierNode!)
        }
        
        return newBarrierNode
    }
    
    
    private func setupBarrier(withRect barrierRect: CGRect, andBarrier barrier: SKShapeNode? = nil) -> SKShapeNode {
    
        var newBarrierNode: SKShapeNode!
        
        if let barrier = barrier {
            newBarrierNode = barrier
            
            newBarrierNode.removeFromParent()
            newBarrierNode.removeAllActions()
            
            newBarrierNode.position = CGPoint.zero
            
        } else {
            let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierRect)
            newBarrierNode = SKShapeNode.init(rect: barrierRect)
            newBarrierNode.physicsBody = barrierBody
            newBarrierNode.physicsBody?.categoryBitMask = 0010
            newBarrierNode.physicsBody?.collisionBitMask = 0000
            newBarrierNode.physicsBody?.contactTestBitMask = 0011
        }
        
        var horizontalDuration = BarrierCreator.DEFAULT_HORIZONTAL_DURATION
        var horizontalDistance = BarrierCreator.DEFAULT_HORIZONTAL_DISTANCE
        var verticalDuration = BarrierCreator.DEFAULT_VERTICAL_DURATION
        var verticalDistance = BarrierCreator.DEFAULT_VERTICAL_DISTANCE
        
        newBarrierNode.fillColor = delegate?.barrierColor(self) ?? BarrierCreator.DEFAULT_BARRIER_COLOR
        
        if let horizontalDistanceAndDuration = delegate?.horizontalMovingDistanceAndDuration(self) {
            horizontalDuration =  horizontalDistanceAndDuration.duration
            horizontalDistance = horizontalDistanceAndDuration.distance
        }
        
        if let verticalDistanceAndDuration = delegate?.verticalMovingDistanceAndDuration(self) {
            verticalDuration =  verticalDistanceAndDuration.duration
            verticalDistance = verticalDistanceAndDuration.distance
        }
        
        newBarrierNode.run(
            SKAction.repeatForever(
                SKAction.moveBy(
                    x: 0,
                    y: verticalDistance,
                    duration: verticalDuration
                )
            )
        )
        
        newBarrierNode.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveBy(
                        x: horizontalDistance,
                        y: 0, duration: horizontalDuration
                    ),
                    SKAction.moveBy(
                        x: -horizontalDistance,
                        y: 0, duration: horizontalDuration
                    )
                ])
            )
        )
    
        return newBarrierNode
    }
}
