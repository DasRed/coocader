//
//  OverlayScene.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class OverlayScene: BaseScene {
    
    // did move to view
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        self.backgroundNode.removeFromParent()
    }
}
