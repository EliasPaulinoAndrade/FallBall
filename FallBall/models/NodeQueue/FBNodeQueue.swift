//
//  BarrierCreator.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

class FBNodeQueue {
    private var nodes: [SKNode] = []
    var delegate: FBNodeQueueDelegate?
    
    func dequeueNode() -> SKNode? {
        var newNode: SKNode?
        
        if let firstNode = self.nodes.first {
            
            if let reuseStrategy = delegate?.resuseStrategy(self),
               reuseStrategy.validadeReuse(ofNode: firstNode) {
                
                delegate?.setupNode(self, node: firstNode)
                
                newNode = firstNode
                
                self.nodes.remove(at: 0)
                self.nodes.append(firstNode)
                
            } else {
                if let node = delegate?.createNode(self) {
                    delegate?.setupNode(self, node: node)
                    self.nodes.append(node)
                    newNode = node
                }
            }
        } else {
            if let node = delegate?.createNode(self) {
                delegate?.setupNode(self, node: node)
                self.nodes.append(node)
                newNode = node
            }
        }
        
        return newNode
    }
}
