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
    
    let player2Sprite = SKSpriteNode(imageNamed: "Spaceship")
    
    var characters: Set<Character> = Set<Character>()
    
    let playerScale: CGFloat    =   0.1
    
    let forwardSpeed: CGFloat   = 300.0
    let backwardSpeed:CGFloat   = 150.0
    let angularSpeed: CGFloat   =   0.05
    
    var bulletOffset: CGFloat   = 0.0
    let bulletSpeed:    CGFloat = 700.0
    
    let reloadTime:      CFTimeInterval = 0.2
    let bulletLifeTime:  CFTimeInterval = 10
    var lastPlayer1Fire: CFTimeInterval = 0
    var lastPlayer2Fire: CFTimeInterval = 0
    
    var player1Bullets: [(SKShapeNode,CFTimeInterval)] = [(SKShapeNode,CFTimeInterval)]()
    var player2Bullets: [(SKShapeNode,CFTimeInterval)] = []
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector.zeroVector
        
        setUpWorld()
    }
    
    func setUpWorld() {
        self.removeAllChildren()
        
        // set up player 1 sprite
        player1Sprite.position = CGPoint(x: CGRectGetMinX(self.frame), y: CGRectGetMidY(self.frame))
        player1Sprite.setScale(playerScale)
        player1Sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: player1Sprite.size)
        player1Sprite.physicsBody?.dynamic = true
        
        self.addChild(player1Sprite)
        
        // set up player 2 sprite
        player2Sprite.position = CGPoint(x: CGRectGetMaxX(self.frame), y: CGRectGetMidY(self.frame))
        player2Sprite.setScale(playerScale)
        player2Sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: player1Sprite.size)
        player2Sprite.physicsBody?.dynamic = true
        
        self.addChild(player2Sprite)
        
        bulletOffset = player1Sprite.frame.height/2.0 + 5
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        updatePlayer1(currentTime)
        updatePlayer2(currentTime)
        if characters.contains(Character("q")) &&
            lastPlayer1Fire.distanceTo(currentTime) > reloadTime &&
            player1Bullets.count < 5 {
            player1Fire(currentTime)
            lastPlayer1Fire = currentTime
        }
        if characters.contains(Character("m")) &&
            lastPlayer2Fire.distanceTo(currentTime) > reloadTime &&
            player2Bullets.count < 5 {
            player2Fire(currentTime)
            lastPlayer2Fire = currentTime
        }
        
        clearBullets(currentTime)
    }
    
    func updatePlayer1(currentTime: CFTimeInterval) {
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
    
    func updatePlayer2(currentTime: CFTimeInterval) {
        let movingForwards  = characters.contains(Character(UnicodeScalar(NSUpArrowFunctionKey)))
        let movingBackwards = characters.contains(Character(UnicodeScalar(NSDownArrowFunctionKey)))
        let turningRight    = characters.contains(Character(UnicodeScalar(NSRightArrowFunctionKey)))
        let turningLeft     = characters.contains(Character(UnicodeScalar(NSLeftArrowFunctionKey)))
        
        if movingBackwards {
            player2Sprite.zRotation += turningRight ? +angularSpeed : 0
            player2Sprite.zRotation += turningLeft  ? -angularSpeed : 0
            
            let backwardVelocity = CGVector(dx: -backwardSpeed * -sin(player2Sprite.zRotation), dy: -backwardSpeed * cos(player2Sprite.zRotation))
            player2Sprite.physicsBody?.velocity = backwardVelocity
            
        } else {
            player2Sprite.zRotation += turningRight ? -angularSpeed : 0
            player2Sprite.zRotation += turningLeft  ? +angularSpeed : 0
            
            let forwardVelocity = CGVector(dx: forwardSpeed * -sin(player2Sprite.zRotation), dy: forwardSpeed * cos(player2Sprite.zRotation))
            player2Sprite.physicsBody?.velocity = movingForwards ? forwardVelocity : CGVector.zeroVector
            
        }
    }
    
    func player1Fire(currentTime: CFTimeInterval) {
        let bullet = SKShapeNode(circleOfRadius: 5)
        bullet.fillColor = NSColor.blackColor()
        bullet.strokeColor = NSColor.blackColor()
        bullet.position = CGPoint(x: player1Sprite.position.x + bulletOffset * player1Sprite.direction.dx, y: player1Sprite.position.y + bulletOffset * player1Sprite.direction.dy)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet.physicsBody?.velocity = CGVector(dx: bulletSpeed * player1Sprite.direction.dx, dy: bulletSpeed * player1Sprite.direction.dy)
        
        self.addChild(bullet)
        
        player1Bullets.append(bullet,currentTime)
    }
    
    func player2Fire(currentTime: CFTimeInterval) {
        let bullet = SKShapeNode(circleOfRadius: 5)
        bullet.fillColor = NSColor.blackColor()
        bullet.strokeColor = NSColor.blackColor()
        bullet.position = CGPoint(x: player2Sprite.position.x + bulletOffset * player2Sprite.direction.dx, y: player2Sprite.position.y + bulletOffset * player2Sprite.direction.dy)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet.physicsBody?.velocity = CGVector(dx: bulletSpeed * player2Sprite.direction.dx, dy: bulletSpeed * player2Sprite.direction.dy)
        
        self.addChild(bullet)
        
        player2Bullets.append(bullet,currentTime)
    }
    
    func clearBullets(currentTime: CFTimeInterval) {
        let expiredP1BulletPairs    = player1Bullets.filter({(bullet, timeFired) in
            return timeFired.distanceTo(currentTime) > self.bulletLifeTime})
        let notExpiredP1BulletPairs = player1Bullets.filter({(bullet, timeFired) in
            return timeFired.distanceTo(currentTime) <= self.bulletLifeTime})
        
        self.removeChildrenInArray(expiredP1BulletPairs.map({$0.0}))
        player1Bullets = notExpiredP1BulletPairs
        
        let expiredP2BulletPairs    = player2Bullets.filter({(bullet, timeFired) in
            return timeFired.distanceTo(currentTime) > self.bulletLifeTime})
        let notExpiredP2BulletPairs = player2Bullets.filter({(bullet, timeFired) in
            return timeFired.distanceTo(currentTime) <= self.bulletLifeTime})
        
        self.removeChildrenInArray(expiredP2BulletPairs.map({$0.0}))
        player2Bullets = notExpiredP2BulletPairs
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

extension SKNode {
    var direction: CGVector {
        get {
            return CGVector(dx: -sin(zRotation), dy: cos(zRotation))
        }
    }
}






