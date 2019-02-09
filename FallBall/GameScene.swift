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
    
    private var ringQueue = FBNodeQueue.init()
    private var jumpSpikesQueue = FBNodeQueue.init()
    
    private var barrierFactory = FBBarrierFactory.init()
    
    var spwanTimer: Timer?
    var pointsTimer: Timer?
    
    
    /// o player
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
    
    
    /// o node do chão, que mata o player
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
    
    
    /// a label que mostra o tempo
    lazy var messageLabel: SKLabelNode = {
        
        let label = SKLabelNode.init(text: "Tap To Play")
        label.fontSize = 50
        label.fontColor = SKColor.white
        
        label.position = CGPoint.init(x: 0, y: -self.size.height/4)
        
        return label
    }()
    
    
    override func didMove(to view: SKView) {
        
        ringQueue.delegate = self
        jumpSpikesQueue.delegate = self

        self.physicsWorld.contactDelegate = self
        
        //adiciona filhos...
        self.addChild(ball)
        self.addChild(floorNode)
        self.addChild(messageLabel)
        
        //inicia pausado
        self.isPaused = true
        
        //cria spikes do teto
        self.createSpikes(numberOfSpikes: 9, spikeHeight: 30)
    }
    
    
    /// Percorre a largura da tela criando spikes que vao ser colocados no teto, para parar a passagem do player
    ///
    /// - Parameters:
    ///   - numberOfSpikes: numero de spikes que devem estar no teto
    ///   - spikeHeight: a altura dos spikes
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
    
    
    /// comeca um timer que vai contar os pontos
    func beginCountPoints() {
        var numberOfSeconds = 0
        self.pointsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.messageLabel.text = "\(numberOfSeconds)"
            numberOfSeconds += 1
        })
    }
    
    
    /// invalida o timer de pontos
    func stopCountPoints() {
        self.pointsTimer?.invalidate()
    }
    
    
    /// inicia a criacao de barreiras pelo tempo usando uma fila de nodes.
    func beginSpawn() {
        self.spwanTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let barrierNode = self.ringQueue.dequeueNode() {
                self.addChild(barrierNode)
            }
            
            if Bool.random() {
                if let barrierNode = self.jumpSpikesQueue.dequeueNode() {
                    self.addChild(barrierNode)
                }
            } 
        }
    }
    
    
    /// invalida o timer de criacao de barreiras
    func stopSpawn() {
        self.spwanTimer?.invalidate()
    }
    
    
    /// joga as barreiras para fora da tela quando o player morre
    func resetBarries() {

        self.scene?.children.forEach({ (child) in
            if child.name == "jumpSpikes" || child.name == "ring" {
                child.position = CGPoint.init(x: self.size.width * 2, y: self.size.height * 2)
            }
        })
    }
    
    
    /// reseta a mesagem para o tamanho inicial
    func resetMessageNode() {
        self.messageLabel.position = CGPoint.init(x: 0, y: -self.size.height/4)
        self.messageLabel.fontSize = 50
    }
    
    
    /// aumenta o tamanho da fonte da label para mostrar a pontuacao
    func centrilizeMessageNode() {
        self.messageLabel.position = CGPoint.zero
        self.messageLabel.fontSize = 100
    }
    
    /// limita a velocidade na bola causada pelo impulso dado.
    override func didSimulatePhysics() {
        if let ballVelocityY = self.ball.physicsBody?.velocity.dy,
           ballVelocityY > GameScene.MAX_BALL_VELOCITY {
            
            self.ball.physicsBody?.velocity.dy = GameScene.MAX_BALL_VELOCITY
        }
    }

    func touchDown(atPoint pos : CGPoint) {
        
        // o estado do jogo muda nesse ponto, somente se o estado atual for initial ou dead.
        if state is InitialState || state is DeadState {
            state.ahead()
        }
        
        // aplica um impulso a bola quando o usuario toca na tela
        self.ball.physicsBody?.applyImpulse(CGVector.init(dx: 0, dy: 500))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        //se um contato acontece entre o player e um obstaculo, vai ao proximo estado, de dead.
        if self.state is PlayingState {
            self.state.ahead()
        }
    }
}

extension GameScene: FBNodeQueueDelegate {
    
    
    /// Cria um node para a nodequeue dependendo da fila de nodes
    ///
    /// - Parameter nodeQueue: a fila de nodes
    /// - Returns: o node criado
    func createNode(_ nodeQueue: FBNodeQueue) -> SKNode {
        
        if nodeQueue == self.ringQueue {
            return barrierFactory.barrier(ofType: .ring, toParentWithRect: self.frame)
        } else if nodeQueue == self.jumpSpikesQueue {
            return barrierFactory.barrier(ofType: .vertical, toParentWithRect: self.frame)
        } else {
            return SKNode.init()
        }
    }
    
    
    /// seta atributos de um node que devem ser setados sempre que ele for reusado
    ///
    /// - Parameters:
    ///   - nodeQueue: a fila de nodes
    ///   - node: o node sendo reutilizado
    func setupNode(_ nodeQueue: FBNodeQueue, node: SKNode) {
        
        node.removeFromParent()
        node.removeAllActions()
        node.position = CGPoint.zero
        
        if let nodeName = node.name {
            if nodeName == "ring" {
                barrierFactory.creator(ofType: .ring)
                    .resetBehaviour(inBarrier: node, inParentWithFrame: self.frame)
            } else {
                barrierFactory.creator(ofType: .vertical)
                    .resetBehaviour(inBarrier: node, inParentWithFrame: self.frame)
            }
        }
    }
    
    func resuseStrategy(_ nodeQueue: FBNodeQueue) -> FBNodeQueueReuseStrategy {
        return FBNodeQueueOutOfSightStrategy.init(withViewPortNode: self)
    }
}
