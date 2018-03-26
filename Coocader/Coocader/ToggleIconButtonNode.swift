//
//  ToggleIconButtonNode.swift
//  Coocader
//
//  Created by Marco Starker on 06.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ToggleIconButtonNode: IconButtonNode {

    // status enabled
    enum Enabled: Int {
        case Off = 0
        case On = 1
    }
    
    // image to use
    private var imageNamed: String!
    
    // status
    var enabled: Enabled! = .On {
        didSet {
            self.icon.texture = self.textureAtlas("icon-button/" + self.imageNamed + "/" + String(self.enabled.rawValue), atlas: .General)
        }
    }

    // setup
    override internal func setup(imageNamed: String) {
        self.imageNamed = imageNamed
        super.setup(imageNamed + "/" + String(Enabled.On.rawValue))
    }
    
    // touch ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.scene!.paused == false else {
            return
        }

        if (self.enabled == .Off) {
            self.enabled = .On
        }
        else {
            self.enabled = .Off
        }
        
        super.touchesEnded(touches, withEvent: event)
    }
}