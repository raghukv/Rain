//
//  GameObject.swift
//  rainSwift
//
//  Created by RaghuKV on 7/28/14.
//  Copyright (c) 2014 RaghuKV. All rights reserved.
//

import Foundation
import SpriteKit


 class GameObject: SKSpriteNode{
    
    convenience init(objectType: GameConstants){
        self.init()
        if(objectType == GameConstants.CONTROL_CIRCLE){
            generateControlCircle()
        }
    }
    
    convenience init(objectType: GameConstants, xAxis: NSInteger){
        self.init()
        if(objectType == GameConstants.DROP_CIRCLE){
            
        }
    }
    
    func generateControlCircle() -> SKSpriteNode
    {
        
        var radius = CGFloat();
        radius = 20.0;
        

        var controlCircle = SKSpriteNode()
        controlCircle.color = UIColor.clearColor()
        controlCircle.size = CGSizeMake(radius * 2, radius * 2);
        
        var circleBody = SKPhysicsBody(circleOfRadius: radius);
        circleBody.dynamic = false
        circleBody.usesPreciseCollisionDetection = true
        
        controlCircle.physicsBody = circleBody
        
        var bodyPath = CGPathCreateWithEllipseInRect(CGRectMake((controlCircle.size.width/2), controlCircle.size.height/2, controlCircle.size.width, controlCircle.size.width),
            nil)
        
        var circleShape = SKShapeNode()
        circleShape.fillColor = UIColor.brownColor()
        circleShape.lineWidth = 0
        circleShape.path = bodyPath
        controlCircle.addChild(circleShape)
        
        return controlCircle
        
    }
}