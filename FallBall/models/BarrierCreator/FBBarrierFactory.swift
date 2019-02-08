//
//  FBBarrierFactory.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

struct FBBarrierFactory {
    
    var rectBarrierCreator = FBRectBarrierCreator.init()
    
    func barrier(ofType: FBBarrierType, toParentWithRect: CGRect) -> SKShapeNode {
        
        return rectBarrierCreator.barrierNode(withParentRect: toParentWithRect)
    }
}
