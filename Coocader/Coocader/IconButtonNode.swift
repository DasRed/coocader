//
//  ColorCircle.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class IconButtonNode: ButtonNode {

    // icon
    let icon: SpriteNode = SpriteNode() 

    // touch status changed
    override var touchStatus: TouchStatus! {
        didSet {
            self.texture = self.textureAtlas("icon-button/background/" + self.touchStatus.rawValue, atlas: .General)
        }
    }

    /* constructor */
    convenience init(_ parent: SKNode, _ imageNamed: String, _ position: CGPoint, _ onTouch: () -> Void) {
        self.init(parent, position, onTouch)
        self.setup(imageNamed)
    }
    
    // setup
    internal func setup(imageNamed: String) {
        self.texture = self.textureAtlas("icon-button/background/" + self.touchStatus.rawValue, atlas: .General)
        
        // Text
        self.icon.texture = self.textureAtlas("icon-button/" + imageNamed, atlas: .General)
        self.icon.userInteractionEnabled = false
        self.icon.position.x = 0
        self.icon.position.y = 0
        self.icon.zPosition = self.zPosition

        self.addChild(self.icon)
    }
}