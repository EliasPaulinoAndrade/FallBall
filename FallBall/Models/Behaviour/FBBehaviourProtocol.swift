//
//  BehaviourProtocol.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Representa um corportamento atribuido a um node. Usado para aplicar actions reutilizaveis em nodes.
protocol FBBehaviourProtocol {
    func run(inNode node: SKNode)
}

