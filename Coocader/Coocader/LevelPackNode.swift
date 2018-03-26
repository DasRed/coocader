import Foundation
import SpriteKit

class LevelPackNode: SKNode, EventManagerProtocol {

    /// Event types
    enum EventType: String, EventTypeProtocol {
        case Play = "levelmode.levelpack.play" // data contains the level pack
    }

    /// the current level pack
    var levelPack: LevelPack!

    /// init with level pack
    init(parent: SKNode, levelPack: LevelPack, delayedRender: Bool = false) {
        self.levelPack = levelPack

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

    /// hmpf usless...
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// setup
    func setup() {
        // background
        let background = SpriteNode(parent: self, texture: "background", atlas: .Level)
        background.userInteractionEnabled = false

        // create the title
        let name = LabelNode(parent: self, text: self.levelPack.name)
        name.position.y = 367
        name.fontSize = 40
        name.strokeColor = Setting.FONT_STROKE_COLOR

        // description
        for (index, text) in self.levelPack.description.characters.split("\n").map(String.init).enumerate() {
            let description = LabelNode(parent: self, text: text)
            description.verticalAlignmentMode = .Top
            description.position.y = CGFloat(287 + (-22 * index))
            description.fontSize = 20
        }

        // level count
        let levelCountLabel = LabelNode(parent: self, text: "x von Y Levels abgeschlossen".localized(self.levelPack.countCompleted, self.levelPack.levels.count))
        levelCountLabel.position.y = -308 // CGFloat(287 + (-22 * 2))
        levelCountLabel.fontSize = 20

        // create the stars
        BigStarsNode(parent: self, difficulty: self.levelPack.difficulty).position = CGPoint(x: 0, y: 317.0)

        // container for levels
        let levelContainer = SpriteNode(parent: self, texture: "levelpack/level-area", atlas: .Level)
        levelContainer.position.y = -35 //-97
        levelContainer.zPosition = self.zPosition

        // create the levels
        var indexY = 0
        let levels = self.levelPack.sorted()
        for (indexX, level) in levels.enumerate() {
            if (indexX != 0 && indexX % 6 == 0) {
                indexY++
            }

            if (indexY > 5 && levels.count > 52) {
                let infoNode = LabelNode(parent: levelContainer, text: "weitere X Level verfügbar".localized(levels.count - 46))
                infoNode.position.y = CGFloat(135 - (indexY * 70))
                infoNode.fontSize = 20
                break
            }

            _ = LevelPackBlockNode(parent: levelContainer, x: indexX, y: indexY, level: level)
        }

        /// completed
        if (self.levelPack.completed == true) {
            SpriteNode(parent: levelContainer, texture: "status/completed-big", atlas: .Level).zPosition = levelContainer.zPosition + 10
        }
        
        self.createConditionals(levelContainer)
    }

    /// create conditionals scene view
    private func createConditionals(levelContainer: SKNode) {
        // test if playable
        if (levelPack.playable == false) {
            let locked = SpriteNode(parent: self, texture: "status/locked-big", atlas: .Level)
            locked.position = levelContainer.position
            locked.zPosition = levelContainer.zPosition + 10

            // pay for level pack
            if (levelPack.storeIdentifier != nil) {
                let button = TextButtonNode(self, "Kaufen".localized, CGPoint(x: 0, y: -358), {}, .highlight)
                button.xScale = 55/90
                button.yScale = 55/90
                button.onTouch = {
                    Store.shared.buy(self.levelPack.storeIdentifier!, completion: {
                        self.levelPack.markAsBuyed()

                        locked.removeFromParent()
                        button.removeFromParent()

                        self.createConditionals(levelContainer)
                    })
                }
            }

            // requirements display
            else if (levelPack.require.count != 0) {
                let textNode = LabelNode(parent: self, text: "Diese Levelpakete müssen abgeschloßen werden:".localized)
                textNode.position.y = -311
                textNode.fontSize = 18

                for (index, id) in levelPack.require.enumerate() {
                    guard let otherLevelPack = levelPack.levelPackHandler.levelPacks[id] else {
                        continue
                    }

                    let textNodeSub = LabelNode(parent: self, text: "- " + otherLevelPack.name)
                    textNodeSub.position.y = CGFloat(-331 - (20 * index))
                    textNodeSub.fontSize = 18
                }
            }
        }

        // play button
        else {
            let button = TextButtonNode(self, "Spielen".localized, CGPoint(x: 0, y: -358), {
                self.trigger(LevelPackNode.EventType.Play, self.levelPack)
            })
            button.xScale = 55/90
            button.yScale = 55/90
        }
    }
}