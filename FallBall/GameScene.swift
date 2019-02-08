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
    
    static private let MAX_BALL_VELOCITY: CGFloat = 500
    
    lazy var state: FBGameState = InitialState.init(scene: self)
    
    private var barrierQueue = FBNodeQueue.init()
    
    var spwanTimer: Timer?
    var pointsTimer: Timer?
    
    lazy var ball: SKShapeNode = {
        let unit = SKScene.unit(forSceneFrame: self.frame)
        
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
        let unit = SKScene.unit(forSceneFrame: self.frame)
        
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
    
    override func didMove(to view: SKView) {
        
        barrierQueue.delegate = self
        self.physicsWorld.contactDelegate = self
        
        self.addChild(ball)
        self.addChild(floorNode)
        self.addChild(messageLabel)
        self.isPaused = true
        self.createSpikes(numberOfSpikes: 9, spikeHeight: 30)
    }
    
    func createSpikes(numberOfSpikes: Int, spikeHeight: CGFloat) {
        let spikeWidth = self.size.width/CGFloat(numberOfSpikes)
        let bezier = UIBezierPath.init()
        
        let initalPoint = CGPoint.init(
            x: -self.size.width/2,
            y: self.size.height/2
        )
        
        var currentPoint = CGPoint.init(
            x: -self.size.width/2,
            y: self.size.height/2 - spikeHeight
        )
        
        bezier.move(to: initalPoint)
        bezier.addLine(to: currentPoint)
        
        (0..<numberOfSpikes).forEach { (_) in
            currentPoint.x += spikeWidth/2
            currentPoint.y -= spikeHeight
            bezier.addLine(to: currentPoint)
            currentPoint.x += spikeWidth/2
            currentPoint.y += spikeHeight
            bezier.addLine(to: currentPoint)
        }
        
        currentPoint.y += spikeHeight
        bezier.addLine(to: currentPoint)
        bezier.addLine(to: initalPoint)
        
        let spikePath = bezier.cgPath
        let spikeNode = SKShapeNode.init(path: spikePath)
        spikeNode.fillColor = SKColor.white
        spikeNode.name = "spike"
        
        let spikeBody = SKPhysicsBody.init(edgeLoopFrom: spikePath)
        spikeNode.physicsBody = spikeBody
        spikeNode.physicsBody?.categoryBitMask = 0010
        spikeNode.physicsBody?.collisionBitMask = 0000
        spikeNode.physicsBody?.contactTestBitMask = 0011
        
        self.addChild(spikeNode)
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
            
            if let barrierNode = self.barrierQueue.dequeueNode() {
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
    
    override func didSimulatePhysics() {
        if let ballVelocityY = self.ball.physicsBody?.velocity.dy,
           ballVelocityY > GameScene.MAX_BALL_VELOCITY {
            
            self.ball.physicsBody?.velocity.dy = GameScene.MAX_BALL_VELOCITY
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if state is InitialState || state is DeadState {
            state.ahead()
        }
        
        self.ball.physicsBody?.applyImpulse(CGVector.init(dx: 0, dy: 500))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if self.state is PlayingState {
            self.state.ahead()
        }
    }
}

extension GameScene: FBNodeQueueDelegate {
    
    func createNode(_ nodeQueue: FBNodeQueue) -> SKNode {
        
        let barrierRect = CGRect.init(
            x: -self.frame.width/2,
            y: self.frame.height/2 - 100,
            width: self.frame.width - 5 * SKScene.unit(forSceneFrame: self.frame),
            height: 20
        )
        
        let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierRect)
        let newBarrierNode = SKShapeNode.init(rect: barrierRect)
        
        newBarrierNode.fillColor = SKColor.white
        newBarrierNode.name = "barrier"
        newBarrierNode.physicsBody = barrierBody
        newBarrierNode.physicsBody?.categoryBitMask = 0010
        newBarrierNode.physicsBody?.collisionBitMask = 0000
        newBarrierNode.physicsBody?.contactTestBitMask = 0011
        
        return newBarrierNode
    }
    
    func setupNode(_ nodeQueue: FBNodeQueue, node: SKNode) {
        
        let unit = SKScene.unit(forSceneFrame: self.frame)
        
        node.removeFromParent()
        node.removeAllActions()
        node.position = CGPoint.zero
        
        node.applyBehaviour(FBFallBehaviour.init(
            duration: 1,
            distance: -300
        ))
        
        node.applyBehaviour(FBBackAndForth.init(
            duration: 2,
            distance: 5 * unit
        ))
    }
    
    func resuseStrategy(_ nodeQueue: FBNodeQueue) -> FBNodeQueueReuseStrategy {
        return FBNodeQueueOutOfSightStrategy.init(withViewPortNode: self)
    }
}
