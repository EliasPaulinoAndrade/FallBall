//
//  FBJumpVerticallyBehaviour.swift
//  FallBall
//
//  Created by Elias Paulino on 09/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

struct FBJumpHorizontallyBehaviour: FBBehaviourProtocol {
    
    var duration: TimeInterval
    var distance: CGFloat
    var initialMovingDistance: CGFloat
    var initialMovingDuration: TimeInterval
    var userReactionTime: TimeInterval
    
    func run(inNode node: SKNode) {
        node.run(
            SKAction.sequence([
                SKAction.moveBy(
                    x: initialMovingDistance,
                    y: 0,
                    duration: initialMovingDuration
                ),
                SKAction.wait(forDuration: userReactionTime),
                SKAction.moveBy(
                    x: distance,
                    y: 0,
                    duration: duration
                ),
                SKAction.wait(forDuration: userReactionTime),
                SKAction.moveBy(
                    x: initialMovingDistance,
                    y: 0,
                    duration: initialMovingDuration
                ),
                SKAction.removeFromParent()
            ])
        )
    }
}
