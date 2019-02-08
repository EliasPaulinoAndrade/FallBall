//
//  BarrierCreatorProtocol.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

protocol BarrierCreatorDelegate {
    func responsible(by: BarrierCreator) -> SKScene
    func verticalMovingDistanceAndDuration(_ creator: BarrierCreator) -> (distance: CGFloat, duration: TimeInterval)
    func horizontalMovingDistanceAndDuration(_ creator: BarrierCreator) -> (distance: CGFloat, duration: TimeInterval)
    func barrierColor(_ creator: BarrierCreator) -> SKColor
}
