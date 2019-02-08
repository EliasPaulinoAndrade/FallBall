//
//  RecangleBarrier.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

class RectBarrier: BarrierProtocol {
    
    static private let DEFAULT_HORIZONTAL_DISTANCE: CGFloat = 10
    static private let DEFAULT_HORIZONTAL_DURATION: TimeInterval = 1
    static private let DEFAULT_VERTICAL_DISTANCE: CGFloat = -300
    static private let DEFAULT_VERTICAL_DURATION: TimeInterval = 2
    static private let DEFAULT_BARRIER_COLOR: SKColor = SKColor.white
    
    func barrierNode(_ barrierProtocol: BarrierProtocol, withRect parentRect: CGRect) -> SKShapeNode {
        
        let barrierRect = CGRect.init(
            x: -parentRect.width/2,
            y: parentRect.height/2 - 100,
            width: parentRect.width - 5 * SKScene.unit(forSceneFrame: parentRect),
            height: 20
        )
        
        let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierRect)
        
        let barrierNode = SKShapeNode.init(rect: barrierRect)
        barrierNode.name = "barrier"
        barrierNode.physicsBody = barrierBody
        barrierNode.physicsBody?.categoryBitMask = 0010
        barrierNode.physicsBody?.collisionBitMask = 0000
        barrierNode.physicsBody?.contactTestBitMask = 0011
        
        return barrierNode
    }
    
}
