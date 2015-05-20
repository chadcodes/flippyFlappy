//
//  GameScene.swift
//  flippyFlappy
//
//  Created by Gavin Thompson on 2015-05-20.
//  Copyright (c) 2015 Gavin Thompson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        var birdTexture = SKTexture( imageNamed: "img/flappy1.png" )
        var birdTexture2 = SKTexture( imageNamed: "img/flappy2.png" )
        
        var animation = SKAction.animateWithTextures ( [birdTexture, birdTexture2], timePerFrame: 0.1 )
        var makePlayerAnimate = SKAction.repeatActionForever( animation )
        
        
        bird = SKSpriteNode( texture: birdTexture )
        bird.position = CGPoint( x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) )
        bird.runAction( makePlayerAnimate )
        
        //physics time!
        bird.physicsBody = SKPhysicsBody( circleOfRadius: bird.size.height/2 )
        bird.physicsBody?.allowsRotation = false
        
        self.addChild( bird )
      
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
