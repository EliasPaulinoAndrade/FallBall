//
//  BarrierCreator.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

class ShapeNodeQueue {
    private var barriers: [SKShapeNode] = []
    var delegate: ShapeNodeQueueDelegate?
    
    func dequeueBarrier() -> SKShapeNode? {
        var newBarrierNode: SKShapeNode?
        
        if let firstBarrier = self.barriers.first {
            
            if let reuseStrategy = delegate?.resuseStrategy(self),
               reuseStrategy.validadeReuse(ofNode: firstBarrier) {
                
                delegate?.setupNode(self, node: firstBarrier)
                
                newBarrierNode = firstBarrier
                
                self.barriers.remove(at: 0)
                self.barriers.append(firstBarrier)
            } else {
                if let newBarrier = delegate?.createNode(self) {
                    delegate?.setupNode(self, node: newBarrier)
                    self.barriers.append(newBarrier)
                    newBarrierNode = newBarrier
                }
            }
        } else {
            if let newBarrier = delegate?.createNode(self) {
                delegate?.setupNode(self, node: newBarrier)
                self.barriers.append(newBarrier)
                newBarrierNode = newBarrier
            }
        }
        
        return newBarrierNode
    }
}
