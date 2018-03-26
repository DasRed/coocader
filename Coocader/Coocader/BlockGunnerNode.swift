//
//  BlockGunnerNode.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class BlockGunnerNode: SpriteNode {
    
    // the current block
    let block: Block!
    
    // init
    init(parent: BlockNode, presentationMode: Bool = false) {
        self.block = parent.block
        
        super.init(parent: parent, texture: "block-gun/" + self.block.color.rawValue)
        self.position.y = -parent.size.height / 2 + 1

        if (presentationMode == false) {
            self.block.addListener(Block.EventType.SwitchedHisColor, { self.texture = self.textureAtlas("block-gun/" + self.block.color.rawValue) }, self)

            // fire action
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(self.block.gunnerInterval)),
                SKAction.runBlock({
                    _ = GunnerShotNode(parent: self, shotColor: self.block.color)
                })
            ])))
        }
    }

    // destruct
    deinit {
        self.block.removeListener(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        self.block = Block()
        
        super.init(coder: aDecoder)
    }
}