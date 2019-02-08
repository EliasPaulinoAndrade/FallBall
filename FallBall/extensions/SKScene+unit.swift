//
//  SKScene+unit.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

extension SKScene {
    
    static func unit(forSceneFrame sceneFrame: CGRect) -> CGFloat {
        let unit = (sceneFrame.width + sceneFrame.height) * 0.05
        return unit
    }
}
