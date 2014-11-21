//
//  GameViewController.swift
//  rainSwift
//
//  Created by RaghuKV on 7/22/14.
//  Copyright (c) 2014 RaghuKV. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        var sceneData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        scene.backgroundColor = SKColor.whiteColor()
        return scene
    }
}
    
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var sceneWidth = self.view.bounds.width * 4
        var sceneHeight = self.view.bounds.height * 4
        var size = CGSizeMake(sceneWidth, sceneHeight)
        var gameScene = GameScene(size: size)
            gameScene.backgroundColor = SKColor.whiteColor()
            let skView = self.view as SKView
            skView.showsDrawCount = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            skView.presentScene(gameScene)
    }
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
