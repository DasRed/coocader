//
//  DeathlineNode.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class DeathlineNode: SpriteNode {

    static let Y_DELTA = CGFloat(20)
    
    // types
    enum DeathType: String {
        case ForUser = "0"
        case ForBlocks = "1"
    }
    
    // death type
    var deathType: DeathType = .ForUser {
        didSet {
            self.createAndStartAnimation()
        }
    }
    
    // init
    init(parent: DefenderZoneNode) {
        super.init(parent: parent, texture: "deathline/type-" + self.deathType.rawValue + "/10")
        
        self.position = CGPoint(x: parent.frame.size.width / 2, y: parent.frame.size.height + DeathlineNode.Y_DELTA)
        self.zPosition = ZPosition.Deathline.rawValue
        self.userInteractionEnabled = false
        self.alpha = GameSetting.shared.deathline.alpha
        
        // physics body
        let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = CategoryBitMask.Deathline.rawValue
        physicsBody.collisionBitMask = CategoryBitMask.Deathline.rawValue | CategoryBitMask.Block.rawValue
        physicsBody.contactTestBitMask = CategoryBitMask.Deathline.rawValue | CategoryBitMask.Block.rawValue
        self.physicsBody = physicsBody
        
        // animation
        self.createAndStartAnimation()
        
        // rewards
        EventManager.sharedEventManager().addListener(GiftNode.EventType.RewardToGive, {(event: Event) in
            let reward = event.data as! Block.Reward
            if (reward != .DeathLineKillsBlocks) {
                return
            }
            
            if (self.deathType == .ForBlocks) {
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                return
            }
            
            let duration = GameSetting.shared.reward.deathLineKillsBlocksDuration.calc()
            self.deathType = .ForBlocks
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(duration)),
                SKAction.runBlock({
                   self.deathType = .ForUser
                })
            ]))
            
            _ = GiftDescriptionLabelNode(parent: self, reward: reward, value: duration)
        }, self)
    }
    
    deinit {
        EventManager.sharedEventManager().removeListener(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createAndStartAnimation() {
        self.removeAllActions()

        var textures: [SKTexture] = []
        for var i: Int = 10; i < 460; i += 10 {
            textures.append(self.textureAtlas("deathline/type-" + self.deathType.rawValue + "/" + String(i)))
        }
        // make the texture animation
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.075)))
    }
}