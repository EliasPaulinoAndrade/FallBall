//
//  FBRoofCreator.swift
//  FallBall
//
//  Created by Cibele Paulino on 15/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FBFRoofCreator: SKShapeNode {
    /// Percorre a largura da tela criando spikes que vao ser colocados no teto, para parar a passagem do player
    ///
    /// - Parameters:
    ///   - numberOfSpikes: numero de spikes que devem estar no teto
    ///   - spikeHeight: a altura dos spikes
    func createRoofWithSpikes(numberOfSpikes: Int, spikeHeight: CGFloat, size: CGSize) -> SKShapeNode{
        let spikeWidth = size.width/CGFloat(numberOfSpikes)
        let bezier = UIBezierPath.init()
        
        let initalPoint = CGPoint.init(
            x: -size.width/2,
            y: size.height/2
        )
        
        var currentPoint = CGPoint.init(
            x: -size.width/2,
            y: size.height/2 - spikeHeight
        )
        
        bezier.move(to: initalPoint)
        bezier.addLine(to: currentPoint)
        
        (0..<numberOfSpikes).forEach { (_) in
            currentPoint.x += spikeWidth/2
            currentPoint.y -= spikeHeight
            bezier.addLine(to: currentPoint)
            currentPoint.x += spikeWidth/2
            currentPoint.y += spikeHeight
            bezier.addLine(to: currentPoint)
        }
        
        currentPoint.y += spikeHeight
        bezier.addLine(to: currentPoint)
        bezier.addLine(to: initalPoint)
        
        let spikePath = bezier.cgPath
        let spikeNode = SKShapeNode.init(path: spikePath)
        spikeNode.fillColor = SKColor.white
        spikeNode.name = "spike"
        
        let spikeBody = SKPhysicsBody.init(edgeLoopFrom: spikePath)
        spikeNode.physicsBody = spikeBody
        spikeNode.physicsBody?.categoryBitMask = 0010
        spikeNode.physicsBody?.collisionBitMask = 0000
        spikeNode.physicsBody?.contactTestBitMask = 0011
        
        return spikeNode
    }
}

