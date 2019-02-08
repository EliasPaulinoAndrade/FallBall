//
//  FBNodeQueueOutOfSightStrategy.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

struct FBNodeQueueOutOfSightStrategy: FBNodeQueueReuseStrategy {
    weak var viewPortNode: SKNode?
    
    init(withViewPortNode viewPortNode: SKNode) {
        self.viewPortNode = viewPortNode
    }
    
    func validadeReuse(ofNode node: SKNode) -> Bool {
        if let viewPort = self.viewPortNode {
            return !viewPort.intersects(node)
        }
        return false
    }
}
