//
//  GameScene.swift
//  TanksForNothing
//
//  Created by Alexandre Lopoukhine on 31/01/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    let player1Sprite = SKSpriteNode(imageNamed: "Spaceship")
    
    var characters: Set<Character> = Set<Character>()
    
    let forwardSpeed: CGFloat   = 300.0
    let backwardSpeed:CGFloat   = 150.0
    let angularSpeed: CGFloat   =   0.05
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector.zeroVector
        
        // set up player 1 sprite
        player1Sprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        player1Sprite.setScale(0.5)
        player1Sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: player1Sprite.size)
        player1Sprite.physicsBody?.dynamic = true
        
        self.addChild(player1Sprite)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let movingForwards  = characters.contains(Character("w"))
        let movingBackwards = characters.contains(Character("s"))
        let turningRight    = characters.contains(Character("d"))
        let turningLeft     = characters.contains(Character("a"))
        
        if movingBackwards {
            player1Sprite.zRotation += turningRight ? +angularSpeed : 0
            player1Sprite.zRotation += turningLeft  ? -angularSpeed : 0
            
            let backwardVelocity = CGVector(dx: -backwardSpeed * -sin(player1Sprite.zRotation), dy: -backwardSpeed * cos(player1Sprite.zRotation))
            player1Sprite.physicsBody?.velocity = backwardVelocity
            
        } else {
            player1Sprite.zRotation += turningRight ? -angularSpeed : 0
            player1Sprite.zRotation += turningLeft  ? +angularSpeed : 0
            
            let forwardVelocity = CGVector(dx: forwardSpeed * -sin(player1Sprite.zRotation), dy: forwardSpeed * cos(player1Sprite.zRotation))
            player1Sprite.physicsBody?.velocity = movingForwards ? forwardVelocity : CGVector.zeroVector
            
        }
        
        
        
    }
    
    
}

// keyboard handling
extension GameScene {
    override func keyDown(theEvent: NSEvent) {
        if let eventChars = theEvent.charactersIgnoringModifiers {
            characters.unionSet(Set<Character>(eventChars))
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        if let eventChars = theEvent.charactersIgnoringModifiers {
            characters.subtractSet(Set<Character>(eventChars))
        }
    }
    
    func handleKeyEvent(theEvent event: NSEvent, keyDown: Bool) {
        
    }
}