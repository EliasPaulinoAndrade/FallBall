//
//  FBRotateBehaviour.swift
//  FallBall
//
//  Created by Elias Paulino on 09/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


struct FBRotateBehaviour: FBBehaviourProtocol {
    
    var duration: TimeInterval
    var angle: CGFloat
    
    func run(inNode node: SKNode) {
        node.run(
            SKAction.repeatForever(
                SKAction.rotate(
                    byAngle: angle,
                    duration: duration
                )
            )
        )
    }
}
