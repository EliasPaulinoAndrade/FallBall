//
//  ShapeNodeQueueReuseStrategy.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Representa uma estrategia de reuso de nodes
protocol FBNodeQueueReuseStrategy {
    func validadeReuse(ofNode node: SKNode) -> Bool
}
