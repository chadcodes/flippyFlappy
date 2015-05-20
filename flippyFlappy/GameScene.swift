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
    var background = SKSpriteNode()
    var pipeSpeed:Double = 0.5

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("check check 1 2 3 ")

        self.createGround()
        self.createBird()
        
        self.addChild( bird )
        self.beginGame()
        
    }
    
    func beginGame(){
        self.beginBackgroundLoop()
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        println("Start flyin' flappy - flap flap!")
        bird.physicsBody?.velocity = CGVectorMake( 0, 0 )
        bird.physicsBody?.applyImpulse( CGVectorMake( 0, 50 ) )

        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if location == bird.position{
                println("Flappy is touched!")
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createBird(){
    
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
        bird.physicsBody?.dynamic = true
        bird.zPosition = 10

    }
    
    func createGround(){
        var ground = SKNode()
        ground.position = CGPointMake(0,0)
        ground.physicsBody = SKPhysicsBody( rectangleOfSize: CGSizeMake( self.frame.size.width, 1) )
        ground.physicsBody?.dynamic = false
        self.addChild( ground )
    }
    
//    func createBackground(){
//        var backgroundTexture = SKTexture( imageNamed: "img/bg.png" )
//        background = SKSpriteNode( texture: backgroundTexture )
//        background.position = CGPoint( x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) )
//        background.size.height = self.frame.height
//        background.zPosition = 0
//        
//        
//        self.addChild( background )
//    }
    
    func beginBackgroundLoop(){
        var backgroundTexture = SKTexture(imageNamed: "img/bg.png" )
        var bgTextureWidth = backgroundTexture?.size().width
        println("BG width: \(bgTextureWidth)")

        var moveBG = SKAction.moveByX( -(bgTextureWidth!), y: 0, duration: 2)
        
        var replace = SKAction.moveByX(bgTextureWidth!, y:0, duration: 0)
        
        var moveBGForever =  SKAction.repeatActionForever( SKAction.sequence([moveBG, replace]) )
        
        var bgCalculation = 1 + self.frame.size.width / ( bgTextureWidth! * 2 )
        
        for var i:CGFloat = 0; i < 3 ; i++ {

            var backgroundSprite = SKSpriteNode(texture: backgroundTexture )
            
            backgroundSprite.position = CGPoint(x: bgTextureWidth! / 2 + bgTextureWidth! * i, y:CGRectGetMidY(self.frame))
            backgroundSprite.size.height = self.frame.height
            
            backgroundSprite.runAction( moveBGForever )
            addChild( backgroundSprite )
    
        }
    }
    
    func MakePipes(){
        
        // create the gap height bit bigger than flappy
        let gapHeight = bird.size.height * 4.3
        
        // move pipes
        var movePipesLeft = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.width / CGFloat(pipeSpeed)))
        var removePipe = SKAction.removeFromParent()
        var moveAndRemove = SKAction.sequence( [movePipesLeft, removePipe] )
        var movementAmount = arc4random() & UInt32( self.frame.size.height )
        var pipeOffset = CGFloat( movementAmount ) - self.frame.size.height / 3
        
        //

    }
}
