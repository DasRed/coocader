//
//  GameHeaderNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class GameButtonNode: SpriteNode {

    // side of bottom
    enum Side: String {
        case Left = "left"
        case Right = "right"
    }
    
    // overlay image
    internal let overlayImage: SpriteNode! = SpriteNode()
    
    // side
    internal let side: Side!
    
    // init
    init(parent: SKNode, side: Side, overlayImage: String) {
        self.side = side
        
        super.init(parent: parent, texture: "game-button-background")
        
        // self stuff
        self.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.zPosition = ZPosition.GameControls.rawValue
        self.userInteractionEnabled = true
        
        // the overlay
        self.overlayImage.texture = self.textureAtlas(overlayImage)
        self.overlayImage.zPosition = ZPosition.GameControls.rawValue
        self.overlayImage.position = CGPoint(x: -1 * self.size.width / 2 + self.overlayImage.size.width / 2 , y: -1 * self.size.height / 2 + self.overlayImage.size.height / 2)
        self.overlayImage.userInteractionEnabled = false
        
        self.addChild(self.overlayImage)
        
        // on the right side
        if (side == .Right) {
            self.position.x = parent.scene!.frame.size.width - self.position.x
            self.xScale = -1 * self.xScale        }
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        self.side = .Left
        
        super.init(coder: aDecoder)
    }
}