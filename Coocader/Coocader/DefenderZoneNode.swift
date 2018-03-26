//
//  DefenderZoneNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class DefenderZoneNode: SKShapeNode, EventManagerProtocol {

    // events
    enum EventType: String, EventTypeProtocol {
        case Move = "game.defenderZone.move" // data is type of CGFloat as delta
        case MoveEnded = "game.defenderZone.moveEnded" // move ended
    }
    
    // border
    static let BORDER_TOP = CGFloat(200.0)
    
    /* point of touch location start */
    private var touchLocationX: CGFloat! = 0.0
    
    // init
    init(parent: SKNode) {
        super.init()
        
        self.path = CGPathCreateWithRect(CGRect(x: 0, y: 0, width: parent.frame.width, height: DefenderZoneNode.BORDER_TOP), nil)
        self.strokeColor = UIColor(white: 1, alpha: 0.0)
        self.position = CGPoint(x: 0, y: 0)
        self.zPosition = ZPosition.Defender.rawValue
        self.userInteractionEnabled = true

        parent.addChild(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // touches began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.scene!.paused == false else {
            return
        }
        
        self.touchLocationX = touches.first!.locationInNode(self).x
    }
    
    // touches move
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.scene!.paused == false else {
            return
        }

        let touchLocationCurrentX = touches.first!.locationInNode(self).x
        let delta = touchLocationCurrentX - self.touchLocationX
        
        self.touchLocationX = touchLocationCurrentX
        
        self.trigger(EventType.Move, delta)
    }
    
    // touches end
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard self.scene!.paused == false else {
            return
        }

        self.trigger(DefenderZoneNode.EventType.MoveEnded)
    }
}