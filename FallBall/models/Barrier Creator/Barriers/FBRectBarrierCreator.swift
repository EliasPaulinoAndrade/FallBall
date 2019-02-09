//
//  RecangleBarrier.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// cria um obstaculo retangular que cai em direcao ao chão e faz um movimento de "vai-e-vem"
class FBRectBarrierCreator: FBBarrierCreatorProtocol {
    
    static private let DEFAULT_HORIZONTAL_DISTANCE: CGFloat = 10
    static private let DEFAULT_HORIZONTAL_DURATION: TimeInterval = 1
    static private let DEFAULT_VERTICAL_DISTANCE: CGFloat = -300
    static private let DEFAULT_VERTICAL_DURATION: TimeInterval = 2
    static private let DEFAULT_BARRIER_COLOR: SKColor = SKColor.white
    
    func barrierNode(withParentRect parentRect: CGRect) -> SKShapeNode {
        
        let barrierRect = CGRect.init(
            x: -parentRect.width/2,
            y: parentRect.height/2,
            width: parentRect.width - 5 * SKScene.unit(forSceneFrame: parentRect),
            height: 20
        )
        
        let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierRect)
        
        let barrierNode = SKShapeNode.init(rect: barrierRect)
        
        barrierNode.fillColor = SKColor.white
        barrierNode.name = "barrier"
        barrierNode.physicsBody = barrierBody
        barrierNode.physicsBody?.categoryBitMask = 0010
        barrierNode.physicsBody?.collisionBitMask = 0000
        barrierNode.physicsBody?.contactTestBitMask = 0011
        
        self.resetBehaviour(inBarrier: barrierNode, inParentWithFrame: parentRect)
        
        return barrierNode
    }
    
    func resetBehaviour(inBarrier barrier: SKNode, inParentWithFrame parentRect: CGRect) {
        
        let unit = SKScene.unit(forSceneFrame: parentRect)
        
        barrier.applyBehaviour(FBFallBehaviour.init(
            duration: 1,
            distance: -300
        ))
        
        barrier.applyBehaviour(FBBackAndForth.init(
            duration: 2,
            distance: 5 * unit
        ))
    }
}
