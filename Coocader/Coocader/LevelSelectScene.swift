import Foundation
import SpriteKit

class LevelSelectScene: LevelPackSelectScene {

    /// the level pack
    private(set) var levelPack: LevelPack!

    /// set level pack data
    override func setData(data: Any) {
        self.levelPack = data as! LevelPack
    }

    /// create the nodes
    override func createNodes() {
        let levels = self.levelPack.sorted()

        if (self.setting.lastSelectedLevels[self.levelPack.id] != nil) {
            for (index, level) in levels.enumerate() {
                if (self.setting.lastSelectedLevels[self.levelPack.id] == level.id) {
                    self.entryIndexSelected = index
                }
            }
        }

        self.levelPackContainer.position.x += CGFloat(-1 * LevelPackSelectScene.POSITION_X_DELTA * self.entryIndexSelected)

        // render the level
        for (index, level) in levels.enumerate() {
            let renderIt = (index == self.entryIndexSelected - 1) || (index == self.entryIndexSelected) || (index == self.entryIndexSelected + 1)
            let node = LevelNode(parent: self.levelPackContainer, level: level, delayedRender: !renderIt)
            node.position.x = CGFloat(index * LevelPackSelectScene.POSITION_X_DELTA)

            // play was pressed
            node.addListener(LevelNode.EventType.Play, {(event: Event) in
                let level = event.data as! LevelPack.Level
                self.controller.sceneHandler.showLevelPlay(level)
                self.setting.lastSelectedLevels[self.levelPack.id] = level.id
            }, self)

            self.levelPackNodes.append(node)
        }
    }

    /// menu toggle
    override func onMenuToggle() {
        self.controller.sceneHandler.showLevelPackSelectScene()
    }

}