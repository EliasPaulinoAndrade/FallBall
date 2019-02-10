//
//  RecangleBarrier.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// cria um obstaculo retangular que cai em direcao ao chão e faz um movimento de "vai-e-vem"
class FBRectBarrierCreator: FBBarrierCreatorProtocol {
    
    /*parametros da animcacao da barreira*/
    static private let HORIZONTAL_DISTANCE_PER_UNIT: CGFloat = 5
    static private let HORIZONTAL_DURATION: TimeInterval = 2
    static private let VERTICAL_DISTANCE: CGFloat = -300
    static private let VERTICAL_DURATION: TimeInterval = 1
    static private let BARRIER_COLOR: SKColor = SKColor.white
    
    /*retorna a barreira criada*/
    func barrierNode(withParentRect parentRect: CGRect) -> SKShapeNode {
        
        //um frame que inicia no canto superior direito da tela, de largura igual a da tela menos 5 unidades
        let barrierRect = CGRect.init(
            x: -parentRect.width/2,
            y: parentRect.height/2,
            width: parentRect.width - 5 * SKScene.unit(forSceneFrame: parentRect),
            height: 20
        )
        
        /// o corpo fisico da barreira
        let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierRect)
        
        /// o node da barreira
        let barrierNode = SKShapeNode.init(rect: barrierRect)
        
        /// seta atributos do node
        barrierNode.fillColor = SKColor.white
        barrierNode.name = "barrier"
        barrierNode.physicsBody = barrierBody
        barrierNode.physicsBody?.categoryBitMask = 0010
        barrierNode.physicsBody?.collisionBitMask = 0000
        barrierNode.physicsBody?.contactTestBitMask = 0011
        
        //reseta o comprotamento do node para o padrao
        self.resetBehaviour(inBarrier: barrierNode, inParentWithFrame: parentRect)
        
        return barrierNode
    }
    
    /*reseta o comportamento da barreira, deve ser usado quando é necessario que o node volte a ter os atributos que tinha no momento da criação. */
    func resetBehaviour(inBarrier barrier: SKNode, inParentWithFrame parentRect: CGRect) {
        //esse metodo deve conter o 'reset' de atributos que necessitam voltar a valores padrão em algum tempo.
        //normalmente é chamado quando a barreira vai ser reutilizada
        
        let unit = SKScene.unit(forSceneFrame: parentRect)
        
        barrier.removeAllActions()
        barrier.position = CGPoint.zero
        
        //ver documentacao sobre behaviours
        barrier.applyBehaviour(FBFallBehaviour.init(
            duration: FBRectBarrierCreator.VERTICAL_DURATION,
            distance: FBRectBarrierCreator.VERTICAL_DISTANCE
        ))
        
        barrier.applyBehaviour(FBBackAndForth.init(
            duration: FBRectBarrierCreator.HORIZONTAL_DURATION,
            distance: FBRectBarrierCreator.HORIZONTAL_DISTANCE_PER_UNIT * unit
        ))
    }
}
