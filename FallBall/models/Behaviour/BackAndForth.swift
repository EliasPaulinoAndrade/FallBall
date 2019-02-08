//
//  backAndForth.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

struct BackAndForth: BehaviourProtocol {
    
    var duration: TimeInterval
    var distance: CGFloat
    
    func run(inNode node: SKNode) {
        node.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveBy(
                        x: distance,
                        y: 0, duration: duration
                    ),
                    SKAction.moveBy(
                        x: -distance,
                        y: 0, duration: duration
                    )
                ])
            )
        )
    }
}
