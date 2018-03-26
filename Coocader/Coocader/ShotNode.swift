//
//  DefenderZoneNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ShotNode: SpriteNode {

    // shot color
    let shotColor: Block.Color!
    
    // init
    init(parent: SKNode, position: CGPoint, shotColor: Block.Color) {
        self.shotColor = shotColor
        
        super.init(parent: parent, texture: "laserfire/" + self.shotColor.rawValue + "-10")
        
        self.position = position
        self.zPosition = ZPosition.Shot.rawValue
        self.userInteractionEnabled = false

        // physics body
        let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = CategoryBitMask.Shot.rawValue
        physicsBody.collisionBitMask = CategoryBitMask.Shot.rawValue | CategoryBitMask.Block.rawValue | CategoryBitMask.GunnerShot.rawValue
        physicsBody.contactTestBitMask = CategoryBitMask.Shot.rawValue | CategoryBitMask.Block.rawValue | CategoryBitMask.GunnerShot.rawValue
        self.physicsBody = physicsBody

        // make the texture animation
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([
            self.textureAtlas("laserfire/" + self.shotColor.rawValue + "-10"),
            self.textureAtlas("laserfire/" + self.shotColor.rawValue + "-20"),
            self.textureAtlas("laserfire/" + self.shotColor.rawValue + "-30"),
            self.textureAtlas("laserfire/" + self.shotColor.rawValue + "-40"),
        ], timePerFrame: 0.075)))
        
        // run moving actions
        self.runMovingAction()

        // sound for normal shot
        if (self.shotColor != .Spectral) {
            AudioPlayer.shared.playSound(.ShotOfUser)
        }
        // soudn for spectral shot
        else {
            AudioPlayer.shared.playSound(.SpectralShot)
        }
    }
        
    // init
    required init?(coder aDecoder: NSCoder) {
        self.shotColor = Block.Color.Green
        
        super.init(coder: aDecoder)
    }
    
    // runs the moving action
    func runMovingAction() {
        // if node out of screen, stop animation
        if (self.testIfNodeIsOutOfScreen() == true) {
            self.destroy()
            return
        }
        
        let movingDeltaY = GameSetting.shared.shot.movingDeltaY.calc()
        let movingDeltaDuration = GameSetting.shared.shot.movingDeltaDuration.calc()
        
        // the moving action
        let actionMove = SKAction.moveByX(0, y: CGFloat(movingDeltaY), duration: NSTimeInterval(movingDeltaDuration))
        
        // run the actions and after run, recreate the actions
        self.runAction(actionMove, completion: self.runMovingAction)
    }

    // test
    func testIfNodeIsOutOfScreen() -> Bool {
        guard let parent = self.parent else {
            return true
        }
        
        return self.position.y - self.size.height > parent.frame.size.height
    }
    
    // destroyed by a missed shot
    func destroyByMiss() {
        _ = CloudExplosionNode(parent: self, completion: self.destroy)
    }
    
    // shot was hitted... destroy with explosion
    func destroyByHit() {
        _ = ExplosionNode(parent: self, completion: self.destroy)
    }
    
    // destroy this one
    func destroy() {
        self.physicsBody = nil

        self.removeAllActions()
        self.removeFromParent()
    }
}