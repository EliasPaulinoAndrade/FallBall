//
//  SKNode+behaviour.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    func applyBehaviour(_ behaviour: BehaviourProtocol) {
        behaviour.run(inNode: self)
    }
}
