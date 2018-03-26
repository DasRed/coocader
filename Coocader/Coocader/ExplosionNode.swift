//
//  ExplodeNode.swift
//  Coocader
//
//  Created by Marco Starker on 13.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ExplosionNode: SpriteNode {
    
    // init with completion function
    init(parent: SKNode, completion: () -> Void) {
        super.init(parent: parent.parent!, texture: "explosion/1/10")
        
        parent.physicsBody = nil
        parent.removeAllActions()
        parent.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
        
        self.userInteractionEnabled = false
        self.zPosition = ZPosition.ShotExplosion.rawValue
        self.position = parent.position

        var textures: [SKTexture] = []
        for var i = 10; i <= 200; i += 10 {
            textures.append(self.textureAtlas("explosion/1/" + String(i)))
        }

        self.runAction(SKAction.animateWithTextures(textures, timePerFrame: 0.075), completion: {
            self.removeFromParent()
            completion()
        })

        // sound
        AudioPlayer.shared.playSound(.Explosion)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}