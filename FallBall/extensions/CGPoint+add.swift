//
//  CGFloat.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        
        var newPoint = CGPoint.init(x: lhs.x, y: lhs.y)
        newPoint.x += rhs.x
        newPoint.y += rhs.y
        
        return newPoint
    }
}
