//
//  BlockColorSwitchNode.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class BockColorSwitchNode: SKShapeNode {

    // block
    var block: Block!
    
    // init
    init(parent: BlockNode, presentationMode: Bool = false) {
        self.block = parent.block
        
        super.init()

        if (presentationMode == false) {
            // listing to block events
            self.block.addListener(Block.EventType.SwitchedHisColor, {
                self.strokeColor = self.block.color.color()
                self.glowWidth = CGFloat(self.block.countOfColorSwitch)
            }, self)
        }
        // pos
        self.path = CGPathCreateWithRoundedRect(
            CGRect(
                x: -parent.size.width / 2 + 3,
                y: -parent.size.height / 2 + 3,
                width: parent.size.width - 8,
                height: parent.size.height - 8
            ),
            5.0, 5.0, nil
        )
        
        // stuff
        self.alpha = 0.8
        self.strokeColor = self.block.color.color()
        self.lineWidth = 4
        self.glowWidth = CGFloat(self.block.countOfColorSwitch)
        self.zPosition = parent.zPosition + 1
        
        parent.addChild(self)
    }
    
    deinit {
        self.block.removeListener(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        self.block = Block()
        
        super.init(coder: aDecoder)
    }
}