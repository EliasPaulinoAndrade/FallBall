//
//  FBBarrierFactory.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// responsavel por criar barreiras
struct FBBarrierFactory {
    
    var rectBarrierCreator = FBRectBarrierCreator.init()
    var ringBarrierCreator = FBRingBarrierCreator.init()
    var verticalBarrierCreator = FBVerticalSpikesWallBarrierCreator.init()
    
    func barrier(ofType barrierType: FBBarrierType, toParentWithRect: CGRect) -> SKShapeNode {
        
        switch barrierType {
        case .rect:
            return rectBarrierCreator.barrierNode(withParentRect: toParentWithRect)
        case .ring:
            return ringBarrierCreator.barrierNode(withParentRect: toParentWithRect)
        case .vertical:
            return verticalBarrierCreator.barrierNode(withParentRect: toParentWithRect)
        }
    }
    
    func creator(ofType barrierType: FBBarrierType) -> FBBarrierCreatorProtocol {
        switch barrierType {
        case .rect:
            return self.rectBarrierCreator
        case .ring:
            return self.ringBarrierCreator
        case .vertical:
            return self.verticalBarrierCreator
        }
    }
}
