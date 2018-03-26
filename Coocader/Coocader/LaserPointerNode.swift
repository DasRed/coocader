//
//  LaserPointer.swift
//  Coocader
//
//  Created by Marco Starker on 10.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class LaserPointerNode: SpriteNode {
    
    // color selector button node
    private var colorSelectorNode: ColorSelectorButtonNode!

    // bubble node
    private var bubbleNode: SpriteNode!
    
    // colors
    static private var textureColors: [Block.Color: SKTexture]! = [:]
    
    // init
    init(parent: ShipNode, colorSelectorNode: ColorSelectorButtonNode) {
        super.init(parent: parent, texture: "defender/laserpointer/" + colorSelectorNode.selectedColor.rawValue)
        
        self.colorSelectorNode = colorSelectorNode
        self.colorSelectorNode.addListener(ColorSelectorButtonNode.EventType.ColorChanged, self.colorOfColorSelectorWasChanged, self)
        
        self.anchorPoint.y = 0
        self.position.y = parent.size.height / 2
        self.userInteractionEnabled = false
        self.alpha = 0.5

        self.bubbleNode = SpriteNode(parent: self, texture: "laserfire/" + self.colorSelectorNode.selectedColor.rawValue + "-10")
        self.bubbleNode.automaticSizeByTexture = false
        self.bubbleNode.size.width /= 1.5
        self.bubbleNode.size.height /= 1.5
        self.bubbleNode.position.x = 0
        self.bubbleNode.position.y = 0
        self.bubbleNode.userInteractionEnabled = false
        
        let action = SKAction.moveToY(parent.defenderZoneNode.parent!.frame.size.height + self.bubbleNode.size.height , duration: 1.25)
        action.timingMode = .EaseIn
        
        self.bubbleNode.runAction(SKAction.repeatActionForever(SKAction.sequence([
            action,
            SKAction.runBlock({
                self.bubbleNode.position.y = 0
            })
        ])))
    }
    
    // deinit
    deinit {
        self.colorSelectorNode.removeListener(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // the color of selector was changed
    func colorOfColorSelectorWasChanged(event: Event) {
        let color = event.data as! Block.Color
        
        self.texture = self.textureAtlas("defender/laserpointer/" + color.rawValue)
        self.bubbleNode.texture = self.textureAtlas("laserfire/" + color.rawValue + "-10")
    }
}