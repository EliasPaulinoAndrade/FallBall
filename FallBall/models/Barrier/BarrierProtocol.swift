//
//  BarrierProtocol.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

protocol BarrierProtocol {
    func barrierNode(_ barrierProtocol: BarrierProtocol, withRect parentRect: CGRect) -> SKShapeNode
}
