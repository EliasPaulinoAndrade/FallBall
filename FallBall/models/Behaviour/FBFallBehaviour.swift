//
//  FallBehaviour.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

struct FBFallBehaviour: FBBehaviourProtocol {
    
    var duration: TimeInterval
    var distance: CGFloat
    
    func run(inNode node: SKNode) {
        node.run(
            SKAction.repeatForever(
                SKAction.moveBy(
                    x: 0,
                    y: distance,
                    duration: duration
                )
            )
        )
    }
}
