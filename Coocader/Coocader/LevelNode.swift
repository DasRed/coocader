import Foundation
import SpriteKit

class LevelNode: SKNode, EventManagerProtocol {

    /// Event types
    enum EventType: String, EventTypeProtocol {
        case Play = "levelmode.level.play" // data contains the level pack
    }

    /// the current level pack
    var level: LevelPack.Level!

    /// init with level pack
    init(parent: SKNode, level: LevelPack.Level, delayedRender: Bool = false) {
        self.level = level

        super.init()
        parent.addChild(self)

        self.zPosition = ZPosition.Level.rawValue
        self.userInteractionEnabled = false
        
        if (delayedRender == false) {
            self.setup()
        }
        else {
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(Float(10.random(25)) / 10.0)),
                SKAction.runBlock(self.setup)
            ]))
        }
    }

    func setup() {
        // background
        let background = SpriteNode(parent: self, texture: "background", atlas: .Level)
        background.userInteractionEnabled = false

        // create the title
        let name = LabelNode(parent: self, text: self.level.name)
        name.position.y = 367
        name.fontSize = 40
        name.strokeColor = Setting.FONT_STROKE_COLOR

        // create the stars
        BigStarsNode(parent: self, difficulty: Float(self.level.difficulty.asInt() + 1)).position = CGPoint(x: 0, y: 317)

        // container for levels
        let levelContainer = SpriteNode(parent: self, texture: "level/level-area", atlas: .Level)
        levelContainer.position.y = 0
        levelContainer.zPosition = self.zPosition

        // create the levels
        let minY = self.level.matrix.blocks.keys.minElement()!
        let maxY = self.level.matrix.blocks.keys.maxElement()!
        for var i: Int = minY, indexY: Int = max(0, 15 - (maxY - minY + 1)); i < minY + 15; i++, indexY++ {
            guard let blocks = self.level.matrix.blocks[i] else {
                continue
            }

            for block in blocks.values {
                _ = LevelBlockNode(parent: levelContainer, y: indexY, block: block)
            }
        }

        // completed?
        if (self.level.completed == true) {
            let completed = SpriteNode(parent: self, texture: "status/completed-big", atlas: .Level)
            completed.zPosition = levelContainer.zPosition + 10
        }

        // test if playable
        if (self.level.playable == false) {
            let locked = SpriteNode(parent: self, texture: "status/locked-big", atlas: .Level)
            locked.position = levelContainer.position
            locked.zPosition = levelContainer.zPosition + 10

            let textNode = LabelNode(parent: self, text: "Diese Level müssen abgeschloßen werden:".localized)
            textNode.position.y = -311
            textNode.fontSize = 18

            for (index, id) in self.level.require.enumerate() {
                guard let otherLevel = self.level.levelPack.levels[id] else {
                    continue
                }

                let textNodeSub = LabelNode(parent: self, text: "- " + otherLevel.name)
                textNodeSub.position.y = CGFloat(-331 - (20 * index))
                textNodeSub.fontSize = 18
            }
        }
        // play button
        else {
            let button = TextButtonNode(self, "Spielen".localized, CGPoint(x: 0, y: -358), {
                self.trigger(LevelNode.EventType.Play, self.level)
            })
            button.xScale = 55/90
            button.yScale = 55/90
        }
    }

    /// hmpf usless...
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}