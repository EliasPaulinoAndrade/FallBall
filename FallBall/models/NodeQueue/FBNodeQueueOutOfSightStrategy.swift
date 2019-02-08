//
//  FBNodeQueueOutOfSightStrategy.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Uma das estratégia concretas de reutilização de nodes, um node pode ser reutilizado se ele saiu da tela visivel.
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
