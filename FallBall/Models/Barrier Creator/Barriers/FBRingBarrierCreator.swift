//
//  FBRingBarrierCreator.swift
//  FallBall
//
//  Created by Elias Paulino on 08/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation
import SpriteKit


/// Cria um obstaculo de vai-e-vem em forma ciruclar e arrodeado de "spikes"
class FBRingBarrierCreator: FBBarrierCreatorProtocol {
    
    private enum PointType {
        case internal_, external, gap
    }
    
    static private let DEFAULT_HORIZONTAL_DISTANCE: CGFloat = 10
    static private let DEFAULT_HORIZONTAL_DURATION: TimeInterval = 1
    static private let DEFAULT_VERTICAL_DISTANCE: CGFloat = -300
    static private let DEFAULT_VERTICAL_DURATION: TimeInterval = 2
    static private let DEFAULT_BARRIER_COLOR: SKColor = SKColor.white
    
    func barrierNode(withParentRect parentRect: CGRect) -> SKShapeNode {
        
        let barrierDiamenter = parentRect.width - 5 * SKScene.unit(forSceneFrame: parentRect)
        let barrierRadius = barrierDiamenter/2
        let internalBarrierRadius = barrierRadius - 15
        
        let barrierOrigin = CGPoint.zero
        
        let totalAngle: Double = 360
        let spikesAmount: Double = 30
        let angleVariation = totalAngle/spikesAmount
        
        let circleCenter = barrierOrigin + CGPoint(x: barrierRadius, y: barrierRadius)
        let bezierSpikes = UIBezierPath.init()
        
        var currentPoint = point(byAngle: 0, andRadius: barrierRadius, andCenter: circleCenter)
        
        bezierSpikes.move(to: currentPoint)
        
        var lastPointType = PointType.internal_
        for currentAngle in stride(from: 0, through: totalAngle, by: angleVariation) {
            switch lastPointType {
            case .internal_:
                currentPoint = point(byAngle: currentAngle, andRadius: barrierRadius, andCenter: circleCenter)
                bezierSpikes.addLine(to: currentPoint)
                lastPointType = .external
            
            case .external:
                currentPoint = point(byAngle: currentAngle, andRadius: internalBarrierRadius, andCenter: circleCenter)
                bezierSpikes.addLine(to: currentPoint)
                lastPointType = .gap
            case .gap:
                lastPointType = .internal_
            }
        }
 
        let barrierNode = FBCircularSpikedNode.init(path: bezierSpikes.cgPath, centered: true)
        let barrierBody = SKPhysicsBody.init(edgeLoopFrom: barrierNode.path ?? bezierSpikes.cgPath)
        
        barrierNode.fillColor = SKColor.white
        barrierNode.name = "ring"
        barrierNode.physicsBody = barrierBody
        barrierNode.physicsBody?.categoryBitMask = 0010
        barrierNode.physicsBody?.collisionBitMask = 0000
        barrierNode.physicsBody?.contactTestBitMask = 0011
        barrierNode.internalRadius = internalBarrierRadius
        barrierNode.externalRadius = barrierRadius

        self.resetBehaviour(inBarrier: barrierNode, inParentWithFrame: parentRect)
        
        return barrierNode
    }
    
    func point(byAngle angle: Double,
               andRadius barrierRadius: CGFloat,
               andCenter barrierCenter: CGPoint) -> CGPoint {
        
        let initialPointX = (CGFloat(cosin(angle: angle)) * barrierRadius) + barrierCenter.x
        let initialPointY = (CGFloat(sine(angle: angle)) * barrierRadius) + barrierCenter.y
        
        let initialPosition = CGPoint.init(x: initialPointX, y: initialPointY)
        
        return initialPosition
    }
    
    func sine(angle: Double) -> Double {
        let radianAngle = angle * Double.pi / 180
        return sin(radianAngle)
    }
    
    func cosin(angle: Double) -> Double {
        let radianAngle = angle * Double.pi / 180
        return cos(radianAngle)
    }
    
    func resetBehaviour(inBarrier barrier: SKNode, inParentWithFrame parentRect: CGRect) {
        
        guard let spikedNode = barrier as? FBCircularSpikedNode,
              let externalRadius = spikedNode.externalRadius else {
                
            return
        }
        
        let beginsAtRight = Bool.random()
        
        let unit = SKScene.unit(forSceneFrame: parentRect)
        
        barrier.removeAllActions()
        barrier.position = CGPoint.zero
        
        barrier.applyBehaviour(FBFallBehaviour.init(
            duration: 1,
            distance: -300
        ))
        
        barrier.applyBehaviour(FBBackAndForth.init(
            duration: 2,
            distance: beginsAtRight ? (5 * unit) : (-5 * unit)
        ))
        
        barrier.applyBehaviour(FBRotateBehaviour.init(
            duration: 0.1,
            angle: 0.2
        ))
        
        if beginsAtRight {
            barrier.position = CGPoint.init(
                x: -parentRect.width/2 + externalRadius,
                y: parentRect.height/2
            )
        } else {
            barrier.position = CGPoint.init(
                x: parentRect.width/2 - externalRadius,
                y: parentRect.height/2
            )
        }
    }
}
