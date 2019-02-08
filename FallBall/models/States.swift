//
//  States.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit

struct InitialState: GameState {
    
    weak var scene: GameScene?
    
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

struct PlayingState: GameState {
    weak var scene: GameScene?
    
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

struct DeadState: GameState {
    weak var scene: GameScene?
    
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

