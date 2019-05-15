//
//  FBPlayerCreator.swift
//  FallBall
//
//  Created by Cibele Paulino on 15/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FBPlayerCreator: SKShapeNode {
    /// Cria o player
    func createPlayer(frame: CGRect) -> SKShapeNode{
        let unit = SKScene.unit(forSceneFrame: frame)
        
        let ball = SKShapeNode.init(circleOfRadius: unit/2)
        let ballBody = SKPhysicsBody.init(circleOfRadius: unit/2)
        
        ball.lineWidth = 2.5
        ball.fillColor = SKColor.white
        ball.physicsBody = ballBody
        ball.physicsBody?.categoryBitMask = 0001
        ball.physicsBody?.collisionBitMask = 0000
        ball.physicsBody?.contactTestBitMask = 0010
        ball.name = "ball"
        
        return ball
    }
}
