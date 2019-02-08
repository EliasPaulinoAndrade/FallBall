//
//  GameScene.swift
//  FallBall
//
//  Created by Elias Paulino on 07/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    lazy var state: GameState = InitialState.init(scene: self)
    
    private var numberOfTaps: Int = 0
    private var barrierCreator = BarrierCreator.init()
    
    var spwanTimer: Timer?
    var pointsTimer: Timer?
    
    lazy var ball: SKShapeNode = {
        let unit = componentsSizeUnit()
        
        let ball = SKShapeNode.init(circleOfRadius: unit/2)
        let ballBody = SKPhysicsBody.init(circleOfRadius: unit/2)
        
        ball.lineWidth = 2.5
        ball.fillColor = SKColor.white
        ball.physicsBody = ballBody
        ball.physicsBody?.categoryBitMask = 0001
        ball.physicsBody?.collisionBitMask = 0010
        ball.physicsBody?.contactTestBitMask = 0010
        ball.name = "ball"
        
        return ball
    }()
    
    lazy var floor: SKShapeNode = {
        let unit = componentsSizeUnit()
        
        let floorFrame = CGRect.init(
            x: -self.size.width/2,
            y: -self.size.height/2 - unit/2,
            width: self.size.width,
            height: 1
        )
        
        let floor = SKShapeNode.init(rect: floorFrame)
        let floorBody = SKPhysicsBody.init(edgeLoopFrom: floorFrame)
        
        floor.physicsBody = floorBody
        floor.physicsBody?.categoryBitMask = 0010
        floor.physicsBody?.collisionBitMask = 0011
        floor.physicsBody?.contactTestBitMask = 0011
        
        return floor
    }()
    
    lazy var messageLabel: SKLabelNode = {
        
        let label = SKLabelNode.init(text: "Tap To Play")
        label.fontSize = 50
        label.fontColor = SKColor.white
        
        label.position = CGPoint.init(x: 0, y: -self.size.height/4)
        
        return label
    }()
    
    override func didMove(to view: SKView) {
        
        barrierCreator.delegate = self
        self.physicsWorld.contactDelegate = self
        
        self.addChild(ball)
        self.addChild(floor)
        self.addChild(messageLabel)
        self.isPaused = true
    }
    
    func beginCountPoints() {
        var numberOfSeconds = 0
        self.pointsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.messageLabel.text = "\(numberOfSeconds)"
            numberOfSeconds += 1
        })
    }
    
    func stopCountPoints() {
        self.pointsTimer?.invalidate()
    }
    
    func beginSpawn() {
        self.spwanTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            
            let unit = self.componentsSizeUnit()
            
            if let barrierNode = self.barrierCreator.dequeueBarrier(withRect: CGRect.init(
                x: -self.frame.width/2,
                y: self.frame.height/2 - 100,
                width: self.frame.width - 5 * unit,
                height: 20
            )) {
                self.addChild(barrierNode)
            }
        }
    }
    
    func stopSpawn() {
        self.spwanTimer?.invalidate()
    }
    
    func resetBarries() {

        self.scene?.children.forEach({ (child) in
            if child.name != "ball" {
                child.position = CGPoint.init(x: self.size.width * 2, y: self.size.height * 2)
            }
        })
    }
    
    func resetMessageNode() {
        self.messageLabel.position = CGPoint.init(x: 0, y: -self.size.height/4)
        self.messageLabel.fontSize = 50
    }
    
    func centrilizeMessageNode() {
        self.messageLabel.position = CGPoint.zero
        self.messageLabel.fontSize = 100
    }
    
    func componentsSizeUnit() -> CGFloat {
        let w = (self.size.width + self.size.height) * 0.05
        return w
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if state is InitialState || state is DeadState {
            state.ahead()
        }
        
        guard self.numberOfTaps < 2 else {
            return
        }
        
        self.ball.physicsBody?.applyImpulse(CGVector.init(dx: 0, dy: 500))
        self.numberOfTaps += 1
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.numberOfTaps = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

extension GameScene: BarrierCreatorDelegate {
    func responsible(by: BarrierCreator) -> SKScene {
        return self
    }
    
    func verticalMovingDistanceAndDuration(_ creator: BarrierCreator) -> (distance: CGFloat, duration: TimeInterval) {
        return (distance: -300, duration: 1)
    }
    
    func horizontalMovingDistanceAndDuration(_ creator: BarrierCreator) -> (distance: CGFloat, duration: TimeInterval) {
        return (distance: 5 * componentsSizeUnit(), duration: 2)
    }
    
    func barrierColor(_ creator: BarrierCreator) -> SKColor {
        return SKColor.white
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
    
        self.state.ahead()
    }
}
