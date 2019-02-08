//
//  GameState.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Representa um estado do jogo
protocol FBGameState {
    var scene: GameScene? {get set}
    
    /// chamado quando se quer ir ao proximo estado
    func ahead()
}
