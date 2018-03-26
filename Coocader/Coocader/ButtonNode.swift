//
//  ButtonNode.swift
//  Coocader
//
//  Created by Marco Starker on 06.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonNode: SpriteNode {
    
    // status of button
    enum TouchStatus: String {
        case normal = "0"
        case pressed = "1"
    }
    
    // callback
    var onTouch: (() -> Void)! = {}
    
    // current status
    var touchStatus: TouchStatus! = .normal
    
    // init
    init(_ parent: SKNode, _ position: CGPoint, _ onTouch: () -> Void) {
        super.init(parent: parent)
        self.setup(parent, position, onTouch)
    }
    
    // setup
    internal func setup(parent: SKNode, _ position: CGPoint, _ onTouch: () -> Void) {
        self.userInteractionEnabled = true
        self.position = position
        self.zPosition = ZPosition.Buttons.rawValue
        self.onTouch = onTouch
    }
     
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // touch starts
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.scene!.paused == false else {
            return
        }

        self.touchStatus = .pressed
    }
    
    // touch ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.scene!.paused == false else {
            return
        }

        self.touchStatus = .normal
        
        self.onTouch()
    }
}