//
//  States.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Estado inicial do game, antes o usuário clicar na tela
struct InitialState: FBGameState {
    
    weak var scene: GameScene?
    
    
    /// vai para o estado de Playing e seta o jogo inicialmente
    func ahead() {
        self.scene?.isPaused = false
        self.scene?.beginSpawn()
        self.scene?.messageLabel.text = "0"
        self.scene?.beginCountPoints()
        self.scene?.centrilizeMessageNode()
        
        if let scene = self.scene {
            self.scene?.state = PlayingState.init(scene: scene)
        }
    }
}


/// Estado de jogando, enquanto o usuário interage com a tela
struct PlayingState: FBGameState {
    weak var scene: GameScene?
    
    
    /// o proximo estado é o de morte, portando o jogo é pausado.
    func ahead() {
        self.scene?.isPaused = true
        self.scene?.ball.position = CGPoint.zero
        self.scene?.stopSpawn()
        self.scene?.stopCountPoints()
        self.scene?.resetMessageNode()
        self.scene?.messageLabel.text = "Your Are Dead. Tap To Replay"
        
        if let scene = self.scene {
            self.scene?.state = DeadState.init(scene: scene)
        }
    }
}


/// Estando em que o usuario morreu
struct DeadState: FBGameState {
    weak var scene: GameScene?
    
    
    /// o proximo estado, playing, é chamado quando o usuário da um tap na tela
    func ahead() {
        self.scene?.isPaused = false
        
        self.scene?.ball.position = CGPoint.zero
        self.scene?.beginSpawn()
        self.scene?.beginCountPoints()
        self.scene?.resetBarries()
        self.scene?.centrilizeMessageNode()
        self.scene?.messageLabel.text = "0"
        self.scene?.ball.physicsBody?.velocity = CGVector.zero
        
        
        if let scene = self.scene {
            self.scene?.state = PlayingState.init(scene: scene)
        }
    }
}

