//
//  GameScene.swift
//  TanksForNothing
//
//  Created by Alexandre Lopoukhine on 31/01/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player1Sprite = SKSpriteNode(imageNamed: "Spaceship")
    
    let player2Sprite = SKSpriteNode(imageNamed: "Spaceship")
    
    var characters: Set<Character> = Set<Character>()
    
    let playerScale: CGFloat    =   0.1
    
    let forwardSpeed: CGFloat   = 300.0
    let backwardSpeed:CGFloat   = 150.0
    let angularSpeed: CGFloat   =   0.05
    
    var bulletOffset: CGFloat   = 0.0 // reset in setup world
    let bulletSpeed:    CGFloat = 900.0
    
    let reloadTime:      CFTimeInterval = 0.2
    let bulletLifeTime:  CFTimeInterval = 10
    var lastPlayer1Fire: CFTimeInterval = 0
    var lastPlayer2Fire: CFTimeInterval = 0
    
    var player1Bullets: [(SKShapeNode,CFTimeInterval)] = [(SKShapeNode,CFTimeInterval)]()
    var player2Bullets: [(SKShapeNode,CFTimeInterval)] = []
    
    var player1Score: UInt64 = 0
    var player2Score: UInt64 = 0
    
    var startTimeOut:   Bool            = false
    var timeOutStart:   CFTimeInterval  = CFTimeInterval.infinity
    var timeOut:        CFTimeInterval  = 3
    
    let wallThickness: CGFloat = 2
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector.zeroVector
        self.physicsWorld.contactDelegate = self
        
        setUpWorld()
        
    }
    
    func setUpWorld() {
        self.removeAllChildren()
        
        // Add score label after deleting it
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame)*0.9)
        scoreLabel.text = "Player 1: \(player1Score)    Player 2: \(player2Score)"

        self.addChild(scoreLabel)

        // set up player 1 sprite
        player1Sprite.position = playerStartingPositions.leftSquare
        player1Sprite.zRotation = 0
        player1Sprite.setScale(playerScale)
        player1Sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: player1Sprite.size)
        player1Sprite.physicsBody?.dynamic = true
        player1Sprite.physicsBody?.categoryBitMask       = SKNodeBitMask.Player.rawValue
        player1Sprite.physicsBody?.contactTestBitMask    = SKNodeBitMask.Bullet.rawValue
        player1Sprite.name = kPlayer1Name
        
        self.addChild(player1Sprite)
        
        // set up player 2 sprite
        player2Sprite.position = playerStartingPositions.rightSquare
        player2Sprite.zRotation = 0
        player2Sprite.setScale(playerScale)
        player2Sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: player1Sprite.size)
        player2Sprite.physicsBody?.dynamic = true
        player1Sprite.physicsBody?.categoryBitMask       = SKNodeBitMask.Player.rawValue
        player1Sprite.physicsBody?.contactTestBitMask    = SKNodeBitMask.Bullet.rawValue
        
        player2Sprite.name = kPlayer2Name
        
        self.addChild(player2Sprite)
        
        bulletOffset = player1Sprite.frame.height/2.0 + 7
        
        // Add walls
        let walls = SKShapeNode(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        walls.position = CGPoint(x: CGRectGetMinX(self.frame), y: CGRectGetMinY(self.frame))
        walls.strokeColor = NSColor.blackColor()
        walls.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        walls.physicsBody?.categoryBitMask = SKNodeBitMask.Wall.rawValue
        walls.physicsBody?.restitution = 0.0
        
        
        self.addChild(walls)
        
        var level1 = Level(width: 7, height: 7)
        
        level1.addWalls(0, y: 0, right: true, top: true)
        level1.addWalls(0, y: 1, right: true, top: false)
        level1.addWalls(0, y: 2, right: true, top: false)
        level1.addWalls(0, y: 3, right: true, top: true)
        
        for pointPair in level1.getPoints(forFrame: CGRectMake(0, 0, 700, 700)) {
//            drawWall(pointPair.0, end: pointPair.1)
        }
        
        drawWall(CGPoint(x: 50, y: 100), end: CGPoint(x: 150, y: 100))
        drawWall(CGPoint(x: 100, y: 150), end: CGPoint(x: 200, y: 150))
        drawWall(CGPoint(x: 50, y: 200), end: CGPoint(x: 200, y: 200))
//        drawWall(CGPoint(x: 50, y: 300), end: CGPoint(x: 150, y: 300))
    }
    
    func drawWall(start: CGPoint, end: CGPoint) {
        let vector = CGVector(dx: end.x - start.x, dy: end.y - start.y)
        let mag = hypot(vector.dx, vector.dy)
        
        let multiplier = wallThickness / 2.0
        
        let vAlong = CGVector(dx: multiplier * vector.dx / mag, dy: multiplier * vector.dy / mag)
        let vPerp = CGVector(dx: -vAlong.dy, dy: vAlong.dx)
        
        // Add the vector so that it would draw at twice the length of original
        // Weirdness in Scene conversion
        // Find fix later
        let point0  = CGPoint(x: start.x - vAlong.dx + vPerp.dx , y: start.y - vAlong.dy + vPerp.dy)
        let point1  = CGPoint(x: end.x   + vAlong.dx + vPerp.dx + vector.dx, y: end.y   + vAlong.dy + vPerp.dy + vector.dy)
        let point2  = CGPoint(x: end.x   + vAlong.dx - vPerp.dx + vector.dx, y: end.y   + vAlong.dy - vPerp.dy + vector.dy)
        let point3  = CGPoint(x: start.x - vAlong.dx - vPerp.dx , y: start.y - vAlong.dy - vPerp.dy)
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, point0.x, point0.y)
        CGPathAddLineToPoint(path, nil, point1.x, point1.y)
        CGPathAddLineToPoint(path, nil, point2.x, point2.y)
        CGPathAddLineToPoint(path, nil, point3.x, point3.y)
        CGPathCloseSubpath(path)
        
        let wall = SKShapeNode(path: path)
        wall.fillColor = NSColor.blackColor()
        wall.strokeColor = NSColor.clearColor()
        let position = CGPoint(x: min(start.x, end.x) , y: min(start.y, end.y))
        wall.position = position
        wall.physicsBody = SKPhysicsBody(polygonFromPath: path)
        wall.physicsBody?.categoryBitMask = SKNodeBitMask.Wall.rawValue
        wall.physicsBody?.dynamic = false
        self.addChild(wall)
    }
    
    func killWorld() {
        
        // Update score
        if player1Sprite.parent != nil {
            player1Score++
        }
        if player2Sprite.parent != nil {
            player2Score++
        }
        
        setUpWorld()
    }
    
    func playerSpriteMake() {
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        updatePlayer1(currentTime)
        updatePlayer2(currentTime)
        
        player1Sprite.physicsBody?.angularVelocity = 0
        player2Sprite.physicsBody?.angularVelocity = 0
        
        if player1Sprite.parent != nil {
            if characters.contains(Character("q")) &&
                lastPlayer1Fire.distanceTo(currentTime) > reloadTime &&
                player1Bullets.count < 5 {
                    player1Fire(currentTime)
                    lastPlayer1Fire = currentTime
            }
        }
        if player2Sprite.parent != nil {
            if characters.contains(Character("m")) &&
                lastPlayer2Fire.distanceTo(currentTime) > reloadTime &&
                player2Bullets.count < 5 {
                    player2Fire(currentTime)
                    lastPlayer2Fire = currentTime
            }
        }
        
        clearBullets(currentTime)
        
        if characters.contains(Character("p")) {
            if CFTimeInterval.infinity == timeOutStart {
                setUpWorld()
            }
        }
        
        if startTimeOut {
            timeOutStart = currentTime
            startTimeOut = false
        }
        
        if timeOutStart.distanceTo(currentTime) > timeOut {
            timeOutStart = CFTimeInterval.infinity
            player1Bullets.removeAll(keepCapacity: false)
            player2Bullets.removeAll(keepCapacity: false)
            killWorld()
        }
    }
    
    func updatePlayer1(currentTime: CFTimeInterval) {
        let movingForwards  = characters.contains(Character("e"))
        let movingBackwards = characters.contains(Character("d"))
        let turningRight    = characters.contains(Character("f"))
        let turningLeft     = characters.contains(Character("s"))
        
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
    
    func bulletMake(currentTime: CFTimeInterval) -> SKShapeNode {
        let bullet = SKShapeNode(circleOfRadius: 5)
        bullet.fillColor = NSColor.blackColor()
        bullet.strokeColor = NSColor.blackColor()
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        
        // Category is bullet
        bullet.physicsBody?.categoryBitMask = SKNodeBitMask.Bullet.rawValue
        // Collides with player and wall
        bullet.physicsBody?.collisionBitMask = SKNodeBitMask.Player.rawValue + SKNodeBitMask.Wall.rawValue
        // Notifications sent on player collisions only
        bullet.physicsBody?.contactTestBitMask  = SKNodeBitMask.Player.rawValue
        bullet.physicsBody?.restitution = 1.0
        bullet.physicsBody?.friction = 0.0
        
        bullet.name = kBulletName
        
        return bullet
    }
    
    func player1Fire(currentTime: CFTimeInterval) {
        let bullet = bulletMake(currentTime)
        bullet.position = CGPoint(x: player1Sprite.position.x + bulletOffset * player1Sprite.direction.dx, y: player1Sprite.position.y + bulletOffset * player1Sprite.direction.dy)
        bullet.physicsBody?.velocity = CGVector(dx: bulletSpeed * player1Sprite.direction.dx, dy: bulletSpeed * player1Sprite.direction.dy)
        
        self.addChild(bullet)
        
        player1Bullets.append(bullet,currentTime)
        
    }
    
    func player2Fire(currentTime: CFTimeInterval) {
        let bullet = bulletMake(currentTime)
        bullet.position = CGPoint(x: player2Sprite.position.x + bulletOffset * player2Sprite.direction.dx, y: player2Sprite.position.y + bulletOffset * player2Sprite.direction.dy)
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        contact.bodyA.node?.removeFromParent()
        contact.bodyB.node?.removeFromParent()
        
        
        startTimeOut = true
        
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

enum SKNodeBitMask: UInt32 {
    case Player = 1
    case Bullet = 2
    case Wall   = 4
}

let kPlayer1Name = "Player 1"
let kPlayer2Name = "Player 2"
let kBulletName  = "Bullet"




