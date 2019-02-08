//
//  BarrierProtocol.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Representa alguem responsavel por criar um tipo de obstaculo
protocol FBBarrierCreatorProtocol {
    func barrierNode(withParentRect parentRect: CGRect) -> SKShapeNode
    func resetBehaviour(inBarrier barrier: SKNode, inParentWithFrame parentRect: CGRect)
}
