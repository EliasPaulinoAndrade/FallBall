//
//  FBVerticalSpikesWallBarrierCreator.swift
//  FallBall
//
//  Created by Elias Paulino on 09/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

class FBVerticalSpikesWallBarrierCreator: FBBarrierCreatorProtocol {
    
    func barrierNode(withParentRect parentRect: CGRect) -> SKShapeNode {
        
        let barrierHeight = parentRect.height - 10 * SKScene.unit(forSceneFrame: parentRect)
        
        let verticalOrigin = CGFloat.random(
            in: (-parentRect.height/2) ... (parentRect.height/2 - barrierHeight)
        )
        
        let originPoint = CGPoint.init(
            x: -parentRect.width/2 - 30,
            y: 0
        )
        
        let numberOfSpikes = 5
        let spikeSize = barrierHeight/(2 * CGFloat(numberOfSpikes))
        
        let bezier = UIBezierPath.init()
        
        var spikesCurrentPosition = originPoint + CGPoint(x: 10, y: 0)
            
        bezier.move(to: originPoint)
        bezier.addLine(to: spikesCurrentPosition)
        
        (0..<numberOfSpikes).forEach { (currentSpikeIndex) in
            spikesCurrentPosition = spikesCurrentPosition + CGPoint.init(x: 0, y: spikeSize)
            
            bezier.addLine(to: spikesCurrentPosition)
            
            spikesCurrentPosition = spikesCurrentPosition + CGPoint.init(x: 20, y: spikeSize/2)
                
            bezier.addLine(to: spikesCurrentPosition)
            
            spikesCurrentPosition = spikesCurrentPosition + CGPoint.init(x: -20, y: spikeSize/2)
            
            bezier.addLine(to: spikesCurrentPosition)
        }
        
        spikesCurrentPosition = spikesCurrentPosition + CGPoint.init(x: 0, y: spikeSize)
        
        bezier.addLine(to: spikesCurrentPosition)
        
        bezier.addLine(to: originPoint + CGPoint(x: 0, y: barrierHeight + spikeSize))
        bezier.addLine(to: originPoint)
        
        let barrierBody = SKPhysicsBody.init(edgeLoopFrom: bezier.cgPath)
        let barrierNode = SKShapeNode.init(path: bezier.cgPath)
        
        barrierNode.fillColor = SKColor.white
        barrierNode.name = "jumpSpikes"
        barrierNode.physicsBody = barrierBody
        barrierNode.physicsBody?.categoryBitMask = 0010
        barrierNode.physicsBody?.collisionBitMask = 0000
        barrierNode.physicsBody?.contactTestBitMask = 0011
        
        barrierNode.position.y = verticalOrigin
        
        self.resetBehaviour(inBarrier: barrierNode, inParentWithFrame: parentRect)
        
        return barrierNode
    }
    
    func resetBehaviour(inBarrier barrier: SKNode, inParentWithFrame parentRect: CGRect) {
        
        let barrierHeight = parentRect.height - 10 * SKScene.unit(forSceneFrame: parentRect)
        
        let verticalOrigin = CGFloat.random(
            in: (-parentRect.height/2) ... (parentRect.height/2 - barrierHeight)
        )
        
        barrier.position.y = verticalOrigin
        
        barrier.applyBehaviour(FBJumpHorizontallyBehaviour.init(
            duration: 0.2,
            distance: parentRect.width,
            initialMovingDistance: 20,
            initialMovingDuration: 1,
            userReactionTime: 2
        ))
    }
}
