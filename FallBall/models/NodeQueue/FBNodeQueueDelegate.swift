//
//  NodeQueue.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

protocol FBNodeQueueDelegate {
    func createNode(_ nodeQueue: FBNodeQueue) -> SKNode
    
    func setupNode(_ nodeQueue: FBNodeQueue, node: SKNode)
    
    func resuseStrategy(_ nodeQueue: FBNodeQueue) -> FBNodeQueueReuseStrategy
}
