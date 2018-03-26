//
//  BlockConfig.swift
//  Coocader
//
//  Created by Marco Starker on 07.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class Block: EventManagerProtocol {

    // events
    enum EventType: String, EventTypeProtocol {
        case SwitchedHisColor = "game.block.switchedHisColor" // data contains the block
        case DisabledColorSwitching = "game.block.disabledColorSwitching" // data contains the block
    }
    
    // current position
    internal(set) var position: Block.Position!

    // current size
    internal(set) var size: Block.Size!

    // the current face
    internal(set) var face: Face!
    
    // the current width
    internal(set) var width: Width!
    
    // the current color
    internal(set) var color: Color! {
        didSet {
            guard oldValue != nil else {
                return
            }
            
            self.trigger(EventType.SwitchedHisColor, self)
        }
    }
    
    // the node
    var node: BlockNode?
    
    /// is gunner?
    internal(set) var isGunner: Bool! = false

    /// the shot interval for the gunner
    internal(set) var gunnerInterval: Float!

    /// count of open color switches
    internal(set) var countOfColorSwitch: Int = 0

    /// all colors during color switch
    internal(set) var colorsForColorSwitch: [Color] = []

    /// if the block has a gift, then he does need a reward
    internal(set) var reward: Block.Reward? = nil

    /// game settings
    internal var gameSetting: GameSetting {
        get {
            return GameSetting.shared
        }
    }

    // points by this block
    var points: Int {
        get {
            return self.gameSetting.blockPoint.forDestruction(self)
        }
    }

    /// constructor with full values and a accuracy position
    init(face: Face, width: Width, color: Color, x: Double, y: Double, isGunner: Bool, countOfColorSwitch: Int, reward: Block.Reward? = nil, colorsForColorSwitch: [Color]? = nil) {
        self.face = face
        self.width = width
        self.color = color
        self.size = Block.Size(width: Block.Size.WIDTH * (self.width.toInt() + 1), height: Block.Size.HEIGHT)
        self.position = Block.Position(block: self, x: x, y: y)
        self.isGunner = isGunner
        self.countOfColorSwitch = countOfColorSwitch
        self.reward = reward

        if (self.isGunner == true) {
            self.gunnerInterval = self.gameSetting.blockGunner.calcShotInterval()
        }

        if (colorsForColorSwitch != nil) {
            self.colorsForColorSwitch = colorsForColorSwitch!
        }
    }

    /// constructor with full values and a accuracy position
    init(face: Face, width: Width, color: Color, x: Int, y: Int, isGunner: Bool, countOfColorSwitch: Int, reward: Block.Reward? = nil, colorsForColorSwitch: [Color]? = nil) {
        self.face = face
        self.width = width
        self.color = color
        self.size = Block.Size(width: Block.Size.WIDTH * (self.width.toInt() + 1), height: Block.Size.HEIGHT)
        self.position = Block.Position(block: self, x: x, y: y)
        self.isGunner = isGunner
        self.countOfColorSwitch = countOfColorSwitch
        self.reward = reward

        if (self.isGunner == true) {
            self.gunnerInterval = self.gameSetting.blockGunner.calcShotInterval()
        }

        if (colorsForColorSwitch != nil) {
            self.colorsForColorSwitch = colorsForColorSwitch!
        }
    }

    /// construct with some values rest is definied bei GemSettings
    init(face: Face, width: Width, color: Color, isGunner: Bool? = nil, countOfColorSwitch: Int? = nil, reward: Block.Reward? = nil) {
        self.face = face
        self.width = width
        self.color = color
        self.size = Block.Size(width: Block.Size.WIDTH * (self.width.toInt() + 1), height: Block.Size.HEIGHT)
        self.position = Block.Position(block: self)

        // gunner internval
        self.isGunner = isGunner == nil ? self.gameSetting.blockGunner.calcThatIsGunner() : isGunner!
        if (self.isGunner == true) {
            self.gunnerInterval = self.gameSetting.blockGunner.calcShotInterval()
        }

        // color switcher
        if (countOfColorSwitch != nil) {
            self.countOfColorSwitch = countOfColorSwitch!
        }
        else if (self.gameSetting.blockColorSwitcher.calcThatIsColorSwitcher() == true) {
            self.countOfColorSwitch = self.gameSetting.blockColorSwitcher.calcColorSwitchCount()
        }

        // has a grift so create a reward
        if (reward != nil) {
            self.reward = reward!
        }
        else if (self.gameSetting.blockGiver.calcThatIsGiver(self) == true) {
            self.reward = self.gameSetting.reward.calcReward()
        }
    }
    
    /// random init
    convenience init() {
        self.init(
            face: Face.random(),
            width: Width.random(),
            color: Color.random()
        )
    }
    
    // random with max width
    convenience init(maxWidth: Int) {
        self.init(
            face: Face.random(),
            width: Width.random(maxWidth),
            color: Color.random()
        )
    }

    /// creates a copy of it self
    func copy() -> Block {
        let result = Block(
            face: self.face,
            width: self.width,
            color: self.color,
            x: Double(self.position.matrixAccuracy.x),
            y: Double(self.position.matrixAccuracy.y),
            isGunner: self.isGunner,
            countOfColorSwitch: self.countOfColorSwitch,
            reward: self.reward,
            colorsForColorSwitch: self.colorsForColorSwitch
        )

        return result
    }
    
    // switchs the color if defined
    func switchColor() -> Block {
        guard self.countOfColorSwitch != 0 else {
            return self
        }
        
        guard self.countOfColorSwitch > 0 else {
            self.countOfColorSwitch = 0
            self.trigger(EventType.DisabledColorSwitching, self)
            return self
        }

        // reduce count
        self.countOfColorSwitch--
        
        if (self.countOfColorSwitch == 0) {
            self.trigger(EventType.DisabledColorSwitching, self)
        }

        // switch the color
        if (self.countOfColorSwitch < self.colorsForColorSwitch.count) {
            self.color = self.colorsForColorSwitch[self.countOfColorSwitch]
        }
        else {
            self.color = Color.random()
        }

        return self
    }
}