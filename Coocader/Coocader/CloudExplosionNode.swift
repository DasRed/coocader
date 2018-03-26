//
//  ExplodeNode.swift
//  Coocader
//
//  Created by Marco Starker on 13.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class CloudExplosionNode: SpriteNode {
    
    // init with completion function
    init(parent: SKNode, completion: () -> Void, sound: Bool = true) {
        super.init(parent: parent.parent!, texture: "laserfire/explosion/0/10")
        
        parent.physicsBody = nil
        parent.removeAllActions()
        parent.runAction(SKAction.fadeAlphaTo(0, duration: 1.5))
                
        self.userInteractionEnabled = false
        self.zPosition = ZPosition.ShotExplosion.rawValue
        self.position = parent.position
        
        self.runAction(SKAction.animateWithTextures([
            self.textureAtlas("laserfire/explosion/0/10"),
            self.textureAtlas("laserfire/explosion/0/20"),
            self.textureAtlas("laserfire/explosion/0/30")
        ], timePerFrame: 0.05), completion: {
            self.removeFromParent()
            completion()
        })

        // sound
        if (sound == true) {
            AudioPlayer.shared.playSound(.CloudExplosion)
        }
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}