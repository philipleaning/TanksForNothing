//
//  GameScene.swift
//  TanksForNothing
//
//  Created by Alexandre Lopoukhine on 31/01/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector.zeroVector
        
        let player1Sprite = SKSpriteNode(imageNamed: "Spaceship")
        player1Sprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        player1Sprite.setScale(0.5)
        player1Sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: player1Sprite.size)
        
        
        
        self.addChild(player1Sprite)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = location;
        sprite.setScale(0.5)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
