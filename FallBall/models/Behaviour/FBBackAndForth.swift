//
//  backAndForth.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// O comportamento de vai-e-vem de um node. Ele faz o movimento a partir da posição inicial do node.
struct FBBackAndForth: FBBehaviourProtocol {
    
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
