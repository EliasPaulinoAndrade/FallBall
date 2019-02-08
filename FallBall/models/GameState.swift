//
//  GameState.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameState {
    var scene: GameScene? {get set}
    func ahead() 
}
