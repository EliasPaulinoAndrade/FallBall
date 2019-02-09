//
//  BarrierCreator.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Uma fila usada para reaproveitar nodes tendo em vista alguma estatégia de reuso(é usado economizar no processmento de usar varios nodes sem necessidades)
class FBNodeQueue: NSObject {
    private var nodes: [SKNode] = []
    var delegate: FBNodeQueueDelegate?
    
    
    /// Chame para desempilhar um node de acordo com a estrategia de reuso. Caso a estrategia permita que algum node seja reutilizado, ele vai ser. Se não permitir, um novo node será criado, e ele poderá ser reutilizado no futuro.
    ///
    /// - Returns: o node
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
                    self.nodes.append(node)
                    newNode = node
                }
            }
        } else {
            if let node = delegate?.createNode(self) {
                self.nodes.append(node)
                newNode = node
            }
        }
        
        return newNode
    }
}
