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
    var generationSpeed : Double = 0.05
    var mainCategory : UInt32 = 1 << 0
    var dropCategory: UInt32 = 1 << 1
    var controlCircle = SKSpriteNode();
    var patternSpeed : Double = 5.0;
    var listOfPatterns: NSMapTable = NSMapTable()
    var runGame = NSTimer();
    var patternTimer = NSTimer()
    var gameUtils = GameUtils()
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0,0)
        self.xAxisMax = UInt32(self.frame.width - 20)
        resetAndBeginGame()
        }
    
    func resetAndBeginGame(){
        self.controlCircle = gameUtils.drawControlCircle()
        controlCircle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-600)
        self.addChild(controlCircle)
        gameUtils.fadeIn(controlCircle)
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
        var drop = gameUtils.createDrop()
        var min = self.frame.origin.x + 20
        var max = self.frame.width - 20
        var xValue = Int(arc4random_uniform(UInt32(max - min + 1)))
        drop.position = CGPointMake(CGFloat(xValue) - 4, self.frame.height - 5)
        self.addChild(drop)
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = mainCategory
        var fadeIn = SKAction.fadeAlphaTo(0.9, duration: 0.7)
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
            var drop = gameUtils.createDrop()
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
        
        runGame.invalidate()
        patternTimer.invalidate()
        
        var fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.7)
        var kill = SKAction()
        
        var childList = self.children
        var length = childList.count
        
        
        for(var i = 0; i < length; i++){
            var child : SKNode = childList[i] as SKNode
            child.removeAllActions()
            gameUtils.fadeOutAndKill(child)
        }
        
        var tryAgain = SKSpriteNode()
        var tryText = SKLabelNode(fontNamed: "Futura Medium")
        tryAgain.name = "tryAgain"
        tryText.text = "try Again"
        tryText.name = "tryAgain"
        tryText.fontColor = UIColor.blackColor()
        tryText.fontSize = 128
        tryAgain.addChild(tryText)
        tryAgain.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-200)
        tryAgain.alpha = 0.0
        self.addChild(tryAgain)
        
        var fadeInLabel = SKAction.fadeInWithDuration(2.0)
        tryAgain.runAction(fadeInLabel)
        
    }
    
    override func touchesBegan (touches: NSSet, withEvent event: UIEvent)
    {
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        var nodeName = node.name
        var tryAgain = "tryAgain"
        if(nodeName == tryAgain){
            gameUtils.fadeOutAndKill(node)
            self.resetAndBeginGame()
        }
        
    }
    

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
