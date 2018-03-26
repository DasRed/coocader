//
//  GameHeaderNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class GameHeaderNode: SpriteNode {
    /// label of score
    private(set) var labelScore: LabelNode

    /// label of points
    private(set) var labelValue: LabelNode

    // init
    init(parent: PlayScene) {        
        self.labelScore = LabelNode(text: "Punkte".localized)
        self.labelValue = LabelNode(text: String(parent.points))

        super.init(parent: parent, texture: "game-header-background")
        
        let yDelta = (Setting.sharedSetting().adEnabled ? 0 : 1) * AdHandler.BANNER_HEIGHT

        self.position = CGPoint(x: 375, y: 1184 + yDelta)
        self.zPosition = ZPosition.GameHeader.rawValue
        self.userInteractionEnabled = false
                
        // score text
        self.labelScore.position.x = -207
        self.labelScore.horizontalAlignmentMode = .Left
        self.labelScore.strokeColor = Setting.FONT_STROKE_COLOR
        self.addChild(self.labelScore)
        
        self.labelValue.position.x = 137
        self.labelValue.horizontalAlignmentMode = .Right
        self.labelValue.strokeColor = Setting.FONT_STROKE_COLOR
        self.addChild(self.labelValue)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        self.labelScore = LabelNode(text: "Punkte".localized)
        self.labelValue = LabelNode(text: "0")

        super.init(coder: aDecoder)
    }
}