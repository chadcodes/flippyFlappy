//
//  GameScene.swift
//  flippyFlappy
//
//  Created by Gavin Thompson on 2015-05-20.
//  Copyright (c) 2015 Gavin Thompson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // setting up constant categories for physics body bit masks
    let playerCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
    let pipeCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
    let gapCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100

    
    var bird = SKSpriteNode()
    var pipeSpeed:Double = 150
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        physicsWorld.contactDelegate = self

        self.createGround()
        self.createBird()
        
        self.addChild( bird )
        self.beginGame()
        
    }
    
    func beginGame(){
        println("Frame Size: \(self.frame.height)")
        self.beginBackgroundLoop()
        self.makePipes()
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)

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
            backgroundSprite.zPosition = 0
            addChild( backgroundSprite )
            
        }
    }
    
    func makePipes(){
        
        // create the gap height bit bigger than flappy
        let gapHeight = bird.size.height * 4.3
        
        // move pipes
        var movePipesLeft = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.width / CGFloat(pipeSpeed)))
        var removePipe = SKAction.removeFromParent()
        var moveAndRemove = SKAction.repeatActionForever(SKAction.sequence([movePipesLeft, removePipe]))
        var movementAmount = arc4random() % UInt32( self.frame.size.height/2 )
            println("movementAmount \(movementAmount)")
        var pipeOffset = CGFloat( movementAmount ) - self.frame.size.height/4
            println("pipeOffset \(pipeOffset)")
        
        // create pipe1
        var pipeTexture1 = SKTexture( imageNamed: "img/pipe1.png" )
        var pipe1 = SKSpriteNode( texture: pipeTexture1 )
        pipe1.position = CGPoint( x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + (pipe1.size.height/2) + ( gapHeight/2 ) + pipeOffset )
        pipe1.runAction( moveAndRemove )
        
        pipe1.physicsBody = SKPhysicsBody( rectangleOfSize: pipe1.size )
        pipe1.physicsBody?.dynamic = false
        pipe1.physicsBody?.categoryBitMask = pipeCategory
        pipe1.zPosition = 5
        self.addChild( pipe1 );
        println("Pipe 1: \(pipe1.position)")
        

//        //create pipe2
        var pipeTexture2 = SKTexture( imageNamed: "img/pipe2.png" )
        var pipe2 = SKSpriteNode( texture: pipeTexture2 )
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: (CGRectGetMidY(self.frame) - pipe2.size.height/2 - gapHeight/2 + pipeOffset) )

        pipe2.runAction( moveAndRemove )
//
        pipe2.physicsBody = SKPhysicsBody( rectangleOfSize: pipe2.size )
        pipe2.physicsBody?.dynamic = false
        pipe2.physicsBody?.categoryBitMask = pipeCategory
        pipe2.zPosition = 6
        self.addChild( pipe2 );
        println("Pipe 2: \(pipe2.position)")
//
//        //
        var gap = SKNode()
        
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
        gap.physicsBody = SKPhysicsBody( rectangleOfSize:CGSize(width:pipe1.size.width, height:gapHeight) )
        gap.runAction( moveAndRemove )
        gap.physicsBody?.dynamic = false
        gap.physicsBody?.categoryBitMask = gapCategory
//        gap.physicsBody?.collisionBitMask = gapCategory
        gap.physicsBody?.contactTestBitMask = playerCategory
        gap.zPosition = 7
        self.addChild( gap );
        println("Gap: \(gap.position)")

    }
    

}
