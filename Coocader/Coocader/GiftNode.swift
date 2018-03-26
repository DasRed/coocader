//
//  GiftNode.swift
//  Coocader
//
//  Created by Marco Starker on 13.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class GiftNode: SpriteNode {
    enum EventType: String, EventTypeProtocol {
        case RewardToGive = "game.reward" // data contains the reward... event will be triggerd global
        case ShipWasDestroyed = "game.shipWasDestroyed"
    }
    
    /// the block
    let block: Block!

    /// init with block node
    init(blockNode: BlockNode) {
        self.block = blockNode.block
        
        super.init(parent: blockNode.parent!, texture: "gift/10")
        self.position = blockNode.position
        
        // animate the texture
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(Animation(0.05).frames(10, 30).frame(40, 0.25).frames(50, 150).frameMap().map({(frame: Animation.Frame) in
            return self.textureAtlas("gift/" + frame.name)
        }), timePerFrame: 0.05)))
        
        // physics body
        let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = true
        physicsBody.mass = 1
        physicsBody.density = 0.00001
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = CategoryBitMask.Gift.rawValue
        physicsBody.collisionBitMask = CategoryBitMask.Ship.rawValue | CategoryBitMask.Gift.rawValue
        physicsBody.contactTestBitMask = CategoryBitMask.Ship.rawValue | CategoryBitMask.Gift.rawValue
        self.physicsBody = physicsBody

        physicsBody.applyImpulse(CGVector(dx: 0.0, dy: GameSetting.shared.gift.impulse))
        
        // if node out of screen, stop animation
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(0.5),
            SKAction.runBlock({
                if (self.testIfNodeIsOutOfScreen() == true) {
                    self.destroy()
                }
            })
        ])))

        // sound
        AudioPlayer.shared.playSound(.DropAGift)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        self.block = Block()
        
        super.init(coder: aDecoder)
    }

    /// test if the node out of screen
    func testIfNodeIsOutOfScreen() -> Bool {
        guard let parent = self.scene else {
            return true
        }
        
        return parent.intersectsNode(self) == false
    }
    
    /// destroy by gift
    func destroyByHit() {
        guard let reward = self.block.reward else {
            self.destroy()
            return
        }

        // it was bombing
        if (self.block.reward == .BombTheUser) {
            _ = GiftDescriptionLabelNode(parent: self, reward: reward)
            _ = ExplosionNode(parent: self, completion: {
                self.destroy()
                EventManager.sharedEventManager().trigger(EventType.ShipWasDestroyed)
            })
        }
            
        // let give the reward
        else {
            // sound
            AudioPlayer.shared.playSound(.GiftWasTaken)

            _ = CloudExplosionNode(parent: self, completion: self.destroy, sound: false)
            EventManager.sharedEventManager().trigger(EventType.RewardToGive, reward)
        }
    }
    
    // destroy this one
    func destroy() {
        self.physicsBody = nil
        
        self.removeAllActions()
        self.removeFromParent()
    }
}