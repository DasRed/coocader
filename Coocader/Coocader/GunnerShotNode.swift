//
//  DefenderZoneNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class GunnerShotNode: SpriteNode {
    
    // shot color
    let shotColor: Block.Color!
    
    // init
    init(parent: BlockGunnerNode, shotColor: Block.Color) {
        self.shotColor = shotColor
        
        super.init(parent: parent.scene!, texture: "laserfire/" + self.shotColor.rawValue + "-10")
        
        let blockGunnerNode = parent
        let blockNode = blockGunnerNode.parent as! BlockNode
        let blockContainerNode = blockNode.parent as! BlockContainerNode
        
        self.position.x = blockGunnerNode.position.x + blockNode.position.x + blockContainerNode.position.x
        self.position.y = blockGunnerNode.position.y - blockGunnerNode.size.height / 2 + blockNode.position.y - blockNode.size.height / 2 + blockContainerNode.position.y

        self.zPosition = ZPosition.Shot.rawValue
        self.zRotation = CGFloat(M_PI)
        self.userInteractionEnabled = false
        
        // physics body
        let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = CategoryBitMask.GunnerShot.rawValue
        physicsBody.collisionBitMask = CategoryBitMask.GunnerShot.rawValue | CategoryBitMask.Ship.rawValue
        physicsBody.contactTestBitMask = CategoryBitMask.GunnerShot.rawValue | CategoryBitMask.Ship.rawValue
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

        // sound
        AudioPlayer.shared.playSound(.ShotOfGunnerBlock)
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
        
        let movingDeltaY = GameSetting.shared.blockGunner.shotMovingDeltaY.calc()
        let movingDeltaDuration = GameSetting.shared.blockGunner.shotMovingDeltaDuration.calc()
        
        // the moving action
        let actionMove = SKAction.moveByX(0, y: CGFloat(movingDeltaY), duration: NSTimeInterval(movingDeltaDuration))
        
        // run the actions and after run, recreate the actions
        self.runAction(actionMove, completion: self.runMovingAction)
    }
    
    // test
    func testIfNodeIsOutOfScreen() -> Bool {
        return self.position.y < 0
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