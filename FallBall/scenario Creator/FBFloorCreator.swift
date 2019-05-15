//
//  FBFloorCreator.swift
//  FallBall
//
//  Created by Cibele Paulino on 15/05/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FBFloorCreator: SKShapeNode {
    /// o node do chão, que mata o player
    func createFloor(frame: CGRect, size: CGSize) -> SKShapeNode {
        let unit = SKScene.unit(forSceneFrame: frame)
        
        let floorFrame = CGRect.init(
            x: -size.width/2,
            y: -size.height/2 - unit,
            width: size.width,
            height: 10
        )
        
        let floor = SKShapeNode.init(rect: floorFrame)
        let floorBody = SKPhysicsBody.init(edgeLoopFrom: floorFrame)
        
        floor.physicsBody = floorBody
        floor.physicsBody?.categoryBitMask = 0010
        floor.physicsBody?.collisionBitMask = 0000
        floor.physicsBody?.contactTestBitMask = 0011
        floor.name = "floor"
        
        return floor
    }
}
