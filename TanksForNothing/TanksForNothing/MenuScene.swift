//
//  MenuScene.swift
//  TanksForNothing
//
//  Created by Philip Leaning on 31/01/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import SpriteKit

let kPlayButton = "PlayButton"

class MenuScene: SKScene {

    let playButton = SKLabelNode(fontNamed: "Helvetica")

    override func didMoveToView(view: SKView) {
        let titleLabel = SKLabelNode(fontNamed: "Helvetica")
        titleLabel.text = "Tank Game"
        titleLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 0.8*CGRectGetMaxY(self.frame))
        self.addChild(titleLabel)
        
        playButton.text = "Play"
        playButton.name = kPlayButton
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: 0.5*CGRectGetMaxY(self.frame))
        self.addChild(playButton)
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
        if playButton.containsPoint(theEvent.locationInNode(self)) {
            if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = SKSceneScaleMode.Fill
                
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)

                self.view?.presentScene(scene)
            }
        }
    }
}


