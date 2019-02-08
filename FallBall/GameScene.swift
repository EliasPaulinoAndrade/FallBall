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
        ball.physicsBody?.collisionBitMask = 0000
        ball.physicsBody?.contactTestBitMask = 0010
        ball.name = "ball"
        
        return ball
    }()
    
    lazy var floorNode: SKShapeNode = {
        let unit = componentsSizeUnit()
        
        let floorFrame = CGRect.init(
            x: -self.size.width/2,
            y: -self.size.height/2 - unit,
            width: self.size.width,
            height: 10
        )
        
        let floor = SKShapeNode.init(rect: floorFrame)
        let floorBody = SKPhysicsBody.init(edgeLoopFrom: floorFrame)
        
        floor.physicsBody = floorBody
        floor.physicsBody?.categoryBitMask = 0010
        floor.physicsBody?.collisionBitMask = 0000
        floor.physicsBody?.contactTestBitMask = 0011
        floor.name = "floor"
        
        return floor
    }()
    
    lazy var messageLabel: SKLabelNode = {
        
        let label = SKLabelNode.init(text: "Tap To Play")
        label.fontSize = 50
        label.fontColor = SKColor.white
        
        label.position = CGPoint.init(x: 0, y: -self.size.height/4)
        
        return label
    }()
    
    lazy var skyNode: SKShapeNode = {
        
        let skyRect = CGRect.init(
            x: -self.size.width/2,
            y: self.size.height/2 - 20,
            width: self.size.width,
            height: 20
        )
        
        let sky = SKShapeNode.init(rect: skyRect)
        let skyBody = SKPhysicsBody.init(edgeLoopFrom: skyRect)
        
        sky.physicsBody = skyBody
        skyBody.categoryBitMask = 0010
        skyBody.collisionBitMask = 0000
        skyBody.contactTestBitMask = 0011
        
        sky.fillColor = SKColor.white
        
        return sky
    }()
    
    
    override func didMove(to view: SKView) {
        
        barrierCreator.delegate = self
        self.physicsWorld.contactDelegate = self
        
        self.addChild(ball)
        self.addChild(floorNode)
        self.addChild(messageLabel)
        self.addChild(skyNode)
        self.isPaused = true
        self.createSpikes(numberOfSpikes: 9, spikeHeight: 30)
    }
    
    func createSpikes(numberOfSpikes: Int, spikeHeight: CGFloat) {
        let spikeWidth = self.size.width/CGFloat(numberOfSpikes)
        
        var currentOrigin = CGPoint.init(x: -self.size.width/2, y: self.size.height/2 - 20)
        var pivotPoint = CGPoint.zero
        for _ in 0..<numberOfSpikes {
            
            let bezier = UIBezierPath.init()
            pivotPoint = currentOrigin
            
            bezier.move(to: currentOrigin)
            pivotPoint.x += spikeWidth/2
            pivotPoint.y -= spikeHeight
            bezier.addLine(to: pivotPoint)
            pivotPoint.x += spikeWidth/2
            pivotPoint.y += spikeHeight
            bezier.addLine(to: pivotPoint)
            bezier.addLine(to: currentOrigin)
            currentOrigin = pivotPoint
            
            let spikePath = bezier.cgPath
            
            let spikeNode = SKShapeNode.init(path: spikePath)
            spikeNode.fillColor = SKColor.white
            spikeNode.name = "spike"
            
            let spikeBody = SKPhysicsBody.init(edgeLoopFrom: spikePath)
            
            spikeBody.categoryBitMask = 0010
            spikeBody.collisionBitMask = 0000
            spikeBody.contactTestBitMask = 0011
            spikeNode.physicsBody = spikeBody
            
            self.addChild(spikeNode)
        }
        
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
            if child.name == "barrier" {
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
