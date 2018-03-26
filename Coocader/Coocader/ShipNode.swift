//
//  ShipNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class ShipNode: SpriteNode {

    static let MOVING_LINE = CGFloat(135)
    static let BORDER_LEFT = CGFloat(100)
    static let BORDER_RIGHT = CGFloat(650)
    static let FIRE_DELTA_START_Y = CGFloat(10)
    
    // Moving Status of Ship
    enum MovingStatus: String {
        case Left = "0"
        case StandingStill = "1"
        case Right = "2"
    }
    
    // color selector button node
    private var colorSelectorNode: ColorSelectorButtonNode!
    
    // defender zone
    private(set) var defenderZoneNode: DefenderZoneNode!
   
    // status of Ship
    private var movingStatus: MovingStatus! = .StandingStill {
        didSet {
            self.texture = self.textureAtlas("defender/" + self.colorSelectorNode.selectedColor.rawValue + "-" + self.movingStatus.rawValue)
        }
    }
    
    // last shot time
    private var lastShot: CFAbsoluteTime! = 0

    // current selected color
    var selectedColor: Block.Color {
        get {
            return self.colorSelectorNode.selectedColor
        }
    }
    
    // init
    init(parent: DefenderZoneNode, colorSelectorNode: ColorSelectorButtonNode) {
        self.colorSelectorNode = colorSelectorNode
        self.defenderZoneNode = parent

        super.init(parent: parent, texture: "defender/" + self.colorSelectorNode.selectedColor.rawValue + "-" + self.movingStatus.rawValue)
        
        // events
        self.colorSelectorNode.addListener(ColorSelectorButtonNode.EventType.ColorChanged, self.colorOfColorSelectorWasChanged, self)
        self.defenderZoneNode.addListener(DefenderZoneNode.EventType.Move, self.moveInDefenderZone, self)
        self.defenderZoneNode.addListener(DefenderZoneNode.EventType.MoveEnded, self.moveEndedInDefenderZone, self)

        // self stuff
        self.position = CGPoint(x: parent.frame.size.width / 2, y: ShipNode.MOVING_LINE)
        self.userInteractionEnabled = false
        
        // physics body
        let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = CategoryBitMask.Ship.rawValue
        physicsBody.collisionBitMask = CategoryBitMask.GunnerShot.rawValue | CategoryBitMask.Gift.rawValue | CategoryBitMask.Ship.rawValue
        physicsBody.contactTestBitMask = CategoryBitMask.GunnerShot.rawValue | CategoryBitMask.Gift.rawValue | CategoryBitMask.Ship.rawValue
        self.physicsBody = physicsBody
        
        // create the laserfire
        if (GameSetting.shared.laserPointer.exists == true) {
            _ = LaserPointerNode(parent: self, colorSelectorNode: self.colorSelectorNode)
        }
    }
    
    // deinit
    deinit {
        self.colorSelectorNode.removeListener(self)
        self.defenderZoneNode.removeListener(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // the color of selector was changed
    func colorOfColorSelectorWasChanged() {
        self.texture = self.textureAtlas("defender/" + self.colorSelectorNode.selectedColor.rawValue + "-" + self.movingStatus.rawValue)
    }

    /// the ship fires a shot
    func fire() {
        let current = CFAbsoluteTimeGetCurrent()
        let delta = CFAbsoluteTime(GameSetting.shared.shot.fireWaitingDuration)
        
        if (current - self.lastShot < delta) {
            return
        }
        self.lastShot = CFAbsoluteTimeGetCurrent()
        
        _ = ShotNode(
            parent: self.scene!,
            position: CGPoint(x: self.position.x, y: self.position.y + self.size.height / 2 + ShipNode.FIRE_DELTA_START_Y),
            shotColor: self.colorSelectorNode.selectedColor
        )
    }
    
    // move in defender zone
    func moveInDefenderZone(event: Event) {
        var delta = event.data as! CGFloat
        
        if (self.position.x + delta < ShipNode.BORDER_LEFT) {
            delta = ShipNode.BORDER_LEFT - self.position.x
        }
        
        if (self.position.x + delta > ShipNode.BORDER_RIGHT) {
            delta = ShipNode.BORDER_RIGHT - self.position.x
        }
        
        if (delta != 0) {
            self.position.x += delta
        }
        if (delta < 0) {
            self.movingStatus = .Left
        }
        else if (delta > 0) {
            self.movingStatus = .Right
        }
        else {
            self.movingStatus = .StandingStill
        }
    }
    
    // move ended in defender zone
    func moveEndedInDefenderZone() {
        self.movingStatus = .StandingStill
        self.fire()
    }
}