//
//  GameScene.swift
//  rainSwift
//
//  Created by RaghuKV on 7/22/14.
//  Copyright (c) 2014 RaghuKV. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var xAxisMax : UInt32 = 0
    var generationSpeed : Double = 0.08
    var mainCategory : UInt32 = 1 << 0
    var dropCategory: UInt32 = 1 << 1
    var controlCircle = SKSpriteNode();
    
    var patternSpeed : Double = 5.0;
    
    
    var listOfPatterns: NSMapTable = NSMapTable()
    var runGame = NSTimer();
    var patternTimer = NSTimer()
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0,0)
        self.xAxisMax = UInt32(self.frame.width)
        self.controlCircle = drawControlCircle()

        self.addChild(controlCircle)
        controlCircle.physicsBody?.categoryBitMask = mainCategory
        controlCircle.physicsBody?.contactTestBitMask = dropCategory
        
        
        runGame = NSTimer.scheduledTimerWithTimeInterval(patternSpeed, target: self, selector: "generatePattern", userInfo: nil, repeats: true);
   
        }
    
    
    
    func generatePattern(){
        
        if(patternTimer.valid){
            patternTimer.invalidate()
        }
        
        doRandom()

    }
    
    func doRandom() -> Void{
        

       patternTimer =  NSTimer.scheduledTimerWithTimeInterval(generationSpeed, target: self, selector: "doRandomImpl", userInfo: nil, repeats: true)
        
    }
    
    func doRandomImpl() -> Void{
        var drop = createDrop()
//        var xValue = Int(arc4random_uniform(xAxisMax-10) + 5)
        var xValue = 1
        drop.position = CGPointMake(CGFloat(xValue), self.frame.height-5)
    
        self.addChild(drop)
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = mainCategory
    
    
        var fadeIn = SKAction.fadeAlphaTo(0.8, duration: 0.7)
        var fall = SKAction.moveTo(CGPointMake(drop.position.x, -self.frame.height), duration: 3.0)
        var fallWithFade = SKAction.group([fadeIn, fall])
    
        var kill = SKAction.runBlock({
            drop.removeFromParent()
        })
    
        var animation = SKAction.sequence([fallWithFade, kill])
        drop.runAction(animation)
    }

    
    
    func doPattern(){
        var i:CGFloat = 0;
        while(i<25){
            var drop = createDrop()
            drop.position = CGPointMake(i, self.frame.height)
            self.addChild(drop)
            drop.physicsBody?.categoryBitMask = dropCategory
            drop.physicsBody?.contactTestBitMask = mainCategory
            
            
            var fadeIn = SKAction.fadeAlphaTo(0.8, duration: 0.7)
            var fall = SKAction.moveTo(CGPointMake(drop.position.x, -self.frame.height), duration: 3.0)
            var fallWithFade = SKAction.group([fadeIn, fall])
            
            var kill = SKAction.runBlock({
                drop.removeFromParent()
            })
            
            var animation = SKAction.sequence([fallWithFade, kill])
            drop.runAction(animation)

            i++;
        }
    }
    
    
    func createDrop() -> SKSpriteNode{
        var radius: CGFloat = 10.0
        var drop = SKSpriteNode()
        drop.color = UIColor.clearColor()
        drop.size = CGSizeMake(radius * 2, radius * 2);
        
        var dropBody = SKPhysicsBody(circleOfRadius: radius)
        dropBody.dynamic = true
        dropBody.usesPreciseCollisionDetection = true
        
        drop.physicsBody = dropBody
        
        var dropPath = CGPathCreateWithEllipseInRect(CGRectMake((drop.size.width/2), drop.size.height/2, drop.size.width, drop.size.width),
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
        radius = 20.0;
        var controlCircle = SKSpriteNode()
        controlCircle.color = UIColor.clearColor()
        controlCircle.size = CGSizeMake(radius * 2, radius * 2);
        
        var circleBody = SKPhysicsBody(circleOfRadius: radius)
        circleBody.dynamic = true
        circleBody.usesPreciseCollisionDetection = true
        
        controlCircle.physicsBody = circleBody

        var bodyPath = CGPathCreateWithEllipseInRect(CGRectMake((controlCircle.size.width/2), controlCircle.size.height/2, controlCircle.size.width, controlCircle.size.width),
            nil)
            
        var circleShape = SKShapeNode()
        circleShape.fillColor = UIColor.brownColor()
        circleShape.lineWidth = 0
        circleShape.path = bodyPath
        controlCircle.addChild(circleShape)
        controlCircle.position = CGPointMake(self.frame.width/2, self.frame.height/2)

        return controlCircle
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var currentTouch : CGPoint = touch.locationInNode(self)
        var previousTouch : CGPoint = touch.previousLocationInNode(self)
        
        var circlePosition = controlCircle.position
        
        var difference = CGPointMake(currentTouch.x - previousTouch.x, currentTouch.y - previousTouch.y)
        
        
        var newX = circlePosition.x + difference.x;
        var newY = circlePosition.y + difference.y;
        var newPos = CGPointMake(newX, newY);
        controlCircle.position = newPos;
    }
    
    func didBeginContact(contact: SKPhysicsContact) -> Void{
        
        var firstBody : SKNode = contact.bodyA.node!
        
        var secondBody : SKNode = contact.bodyB.node!
        
        firstBody.removeFromParent()
        secondBody.removeFromParent()
        
        runGame.invalidate()
        patternTimer.invalidate()
    }
    
    override func touchesBegan (touches: NSSet, withEvent event: UIEvent)
    {
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
    }
    
    func drawTriangle(){
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
        triangle.antialiased = false;
        
        self.addChild(triangle)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
