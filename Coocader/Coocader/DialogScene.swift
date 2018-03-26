//
//  DialogScene.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class DialogScene: OverlayScene {

    struct Data {
        var onYes: () -> Void = {}
        var onNo: (() -> Void)?
        var textYes: String = "Ja".localized
        var styleYes: TextButtonNode.Design = .big
        var textNo: String? = "Nein".localized
        var styleNo: TextButtonNode.Design = .unimpressive
        var textA: String = ""
        var textB: String = "Möchtest du noch einmal spielen?".localized

        var removeOnYes: Bool = true
        var removeOnNo: Bool = true
    }

    /// data for dialog
    var data: Data = Data()

    /// set data
    override func setData(data: Any) {
        guard let info = data as? Data else {
            return
        }

        self.data = info
    }

    // in view
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let yDelta = (self.setting.adEnabled ? 0 : 1) * AdHandler.BANNER_HEIGHT
        
        let background = SpriteNode(parent: self, texture: "youLoose-background")
        background.position.x = self.size.width / 2
        background.position.y = self.size.height / 2 - background.size.height / 2 + CGFloat(yDelta) / 2
        background.anchorPoint.y = 0
        
        self.backgroundNode.removeFromParent()
        
        let labelA = LabelNode(text: self.data.textA)
        labelA.position.y = 325
        labelA.strokeColor = Setting.FONT_STROKE_COLOR
        labelA.fontSize = 30
        background.addChild(labelA)
        
        let labelB = LabelNode(text: self.data.textB)
        labelB.position.y = 262
        labelB.strokeColor = labelA.strokeColor
        labelB.fontSize = labelA.fontSize
        background.addChild(labelB)
        
        _ = TextButtonNode(background, self.data.textYes, CGPoint(x: 0, y: 149), {
            if (self.data.removeOnYes == true) {
                self.removeDialog()
            }
            self.data.onYes()
        }, self.data.styleYes)

        if (self.data.textNo != nil && self.data.onNo != nil) {
            _ = TextButtonNode(background, self.data.textNo!, CGPoint(x: 0, y: 52), {
                if (self.data.removeOnNo == true) {
                    self.removeDialog()
                }
                self.data.onNo!()
            }, self.data.styleNo)
        }
    }

    /// removes the dialog
    func removeDialog() {
        self.view!.removeFromSuperview()
    }
}