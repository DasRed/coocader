//
//  ColorCircle.swift
//  Color Pong
//
//  Created by Marco Starker on 14.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class TextButtonNode: ButtonNode {

    // types of buttons
    enum Design: String {
        case big = "big"
        case highlight = "highlight"
        case unimpressive = "unimpressive"
    }
    
    // text
    private let labelText: LabelNode = LabelNode()
    
    // map of font size
    private let fontSizeMap: [Design: CGFloat] = [
        .big: Setting.FONT_SIZE_NORMAL,
        .highlight: Setting.FONT_SIZE_NORMAL,
        .unimpressive: Setting.FONT_SIZE_SMALL
    ]
    
    // design
    var design: Design = .big {
        didSet {
            self.updateDesignDependencies()
        }
    }
    
    // touch status changed
    override var touchStatus: TouchStatus! {
        didSet {
            self.texture = self.textureAtlas("text-button/button-" + self.design.rawValue + "/" + self.touchStatus.rawValue, atlas: .General)
        }
    }

    /* constructor */
    convenience init(_ parent: SKNode, _ text: String, _ position: CGPoint, _ onTouch: () -> Void, _ design: Design = .big) {
        self.init(parent, position, onTouch)

        self.setup(text, design)
        self.automaticSizeByTexture = false
    }
    
    // setup
    internal func setup(text: String, _ design: Design = .big) {
        self.design = design
        
        // Text
        self.labelText.zPosition = self.zPosition + 1
        self.labelText.text = text
        self.addChild(self.labelText)
        
        // design update
        self.updateDesignDependencies()
    }
    
    // updates all dependencies correspondening to the desing
    func updateDesignDependencies() -> TextButtonNode {
        self.texture = self.textureAtlas("text-button/button-" + self.design.rawValue + "/" + self.touchStatus.rawValue, atlas: .General)

        // label
        self.labelText.fontSize = self.fontSizeMap[self.design]
        
        return self
    }
}