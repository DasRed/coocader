//
//  DifficultySelectScene.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class DifficultySelectScene: BaseScene {

    // in view
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // play menu music
        self.audioPlayer.playMusic(.Menu)
        let yDelta = (self.setting.adEnabled ? 0 : 1) * AdHandler.BANNER_HEIGHT

        for (i, difficulty) in GameSetting.Difficulty.enabled().enumerate() {
            var design: TextButtonNode.Design = .big

            if (difficulty == .Extrem) {
                design = .highlight
            }

            // endless play button
            _ = TextButtonNode(self, ("difficult-" + difficulty.rawValue).localized, CGPoint(x: 375, y: 884 + (-150 * i) + yDelta), {
                GameSetting(difficulty: difficulty).declareAsDefault()
                self.controller.sceneHandler.showEndlessPlay()
            }, design)
        }

        // setting toggle button
        self.appendSettingButtons(true)
    }

    /// on menu
    override func onMenuToggle() {
        self.controller.sceneHandler.showMenu()
    }
}