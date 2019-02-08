//
//  NodeQueue.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

protocol ShapeNodeQueueDelegate {
    func createNode(_ nodeQueue: ShapeNodeQueue) -> SKShapeNode
    
    func setupNode(_ nodeQueue: ShapeNodeQueue, node: SKShapeNode)
    
    func resuseStrategy(_ nodeQueue: ShapeNodeQueue) -> ShapeNodeQueueReuseStrategy
}
