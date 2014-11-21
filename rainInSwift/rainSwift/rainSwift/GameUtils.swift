//
//  GameUtils.swift
//  rainSwift
//
//  Created by RaghuKV on 11/21/14.
//  Copyright (c) 2014 RaghuKV. All rights reserved.
//

import Foundation
import spritekit


class GameUtils {
    func createDrop() -> SKSpriteNode{
        var radius: CGFloat = 20.0
        radius = CGFloat(arc4random_uniform(30))
        radius += 20.0
        var drop = SKSpriteNode()
        drop.color = UIColor.clearColor()
        drop.size = CGSizeMake(radius * 2, radius * 2)
        var dropBody = SKPhysicsBody(circleOfRadius: radius)
        dropBody.dynamic = true
        dropBody.usesPreciseCollisionDetection = true
        drop.physicsBody = dropBody
        var dropPath = CGPathCreateWithEllipseInRect(CGRectMake((-drop.size.width/2), -drop.size.height/2, drop.size.width, drop.size.width),
            nil)
        var dropShape = SKShapeNode()
        dropShape.fillColor = UIColor.blackColor();
        dropShape.lineWidth = 0
        drop.name = "dropMask"
        dropShape.path = dropPath
        drop.addChild(dropShape)
        drop.alpha = 0.0
        return drop
    }
    
    func drawControlCircle() -> SKSpriteNode{
        var radius = CGFloat()
        radius = 60.0;
        var mainCircle = SKSpriteNode()
        mainCircle.size = CGSizeMake(radius * 2, radius * 2);
        var circleBody = SKPhysicsBody(circleOfRadius: radius)
        circleBody.dynamic = true
        circleBody.usesPreciseCollisionDetection = true
        mainCircle.physicsBody = circleBody
        var bodyPath : CGPathRef = CGPathCreateWithEllipseInRect(CGRectMake((-mainCircle.size.width/2), -mainCircle.size.height/2, mainCircle.size.width, mainCircle.size.width
            ),
            nil)
        var circleShape = SKShapeNode()
        circleShape.fillColor = UIColor.brownColor()
        circleShape.lineWidth = 2
        circleShape.antialiased = true
        circleShape.path = bodyPath
        mainCircle.addChild(circleShape)
        mainCircle.alpha = 0.0
        
        return mainCircle
    }
    
    func fadeOutAndKill(node: SKNode){
        var fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.7)
        var kill = SKAction.runBlock({
            node.removeFromParent()
        })
        
        var fadeAndKill = SKAction.sequence([fadeOut, kill])
        node.runAction(fadeAndKill)
    }
    
    func fadeIn(node: SKNode){
        var fadeIn = SKAction.fadeInWithDuration(0.7)
        node.runAction(fadeIn)
    }
    
    func drawTriangle() -> SKShapeNode{
        var triangle : SKShapeNode = SKShapeNode()
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(0.0, 0.0))
        path.addLineToPoint(CGPointMake(0.0, 100.0))
        path.addLineToPoint(CGPointMake(100.0, 100.0))
        path.closePath()
        triangle.path = path.CGPath
        triangle.lineWidth = 10.0
        triangle.strokeColor = UIColor.blueColor()
        triangle.fillColor = SKColor.redColor()
        triangle.antialiased = true;
        return triangle
    }

}