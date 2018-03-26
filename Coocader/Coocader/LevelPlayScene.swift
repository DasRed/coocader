import SpriteKit

class LevelPlayScene: PlayScene {

    /// the level
    private(set) var level: LevelPack.Level!

    /// set level data
    override func setData(data: Any) {
        self.level = data as! LevelPack.Level
    }

    // in view
    override func startTheGame() {
        // set level setting
        GameSetting(difficulty: level.gameSetting.difficulty).declareAsDefault()
        self.matrix = level.matrix.copy()

        // create and defined default container node
        self.containerNode = BlockContainerNode(parent: self, initialPositionY: GameSetting.BlockContainer.INITIAL_POSITION_Y_NORMAL)

        // starts
        super.startTheGame()

        _ = LevelNameLabelNode(parent: self, level: self.level)
    }

    /// creates the game header
    override func createGameHeader() {
        super.createGameHeader()

        self.gameHeaderNode.labelScore.text = self.level.levelPack.name
        self.gameHeaderNode.labelScore.fontSize = Setting.FONT_SIZE_SMALL
        self.gameHeaderNode.labelValue.text = String(self.level.index + 1) + "/" + String(self.level.levelPack.levels.count)
        self.gameHeaderNode.labelValue.fontSize = Setting.FONT_SIZE_SMALL
    }

    /// on menu toggle pressed
    override func onMenuToggle() {
        var data = DialogScene.Data()
        data.onYes = {
            self.controller.sceneHandler.showLevelSelectScene(self.level.levelPack)
        }
        data.onNo = {
            self.paused = false
        }
        data.textA = "Möchtest du wirklich aufhören zu spielen?".localized
        data.textB = "Der Levelfortschritt wird nicht gespeichert!".localized

        self.controller.sceneHandler.showDialog(data)
    }

    /// the game was lost
    override func youLoose() {
        var data = DialogScene.Data()
        data.onYes = {
            self.controller.sceneHandler.showLevelPlay(self.level)
        }
        data.onNo = {
            self.controller.sceneHandler.showLevelSelectScene(self.level.levelPack)
        }
        data.textA = "Du hast verloren!".localized

        self.controller.sceneHandler.showDialog(data)

        super.youLoose()
    }

    /// the game was won
    override func youWon() {
        self.level.completed = true
        self.level.levelPack.reportForAchievement()

        let nextLevel = self.level.nextPlayable
        var data = DialogScene.Data()
        data.textA = "Du hast gewonnen!".localized

        // got to the next level?
        if (nextLevel != nil) {
            data.onYes = {
                self.controller.sceneHandler.showLevelPlay(nextLevel!)
            }
            data.onNo = {
                self.controller.sceneHandler.showLevelSelectScene(self.level.levelPack)
            }
            data.textB = "Möchtest du das nächste Level spielen".localized

        }
        // levelpack is done
        else {
            data.onYes = {
                self.controller.sceneHandler.showLevelPackSelectScene()
            }
            data.onNo = nil
            data.textYes = "Okay".localized
            data.textB = "Alle Level in diesem Levelpack sind abgeschlossen".localized
        }

        self.controller.sceneHandler.showDialog(data)

        super.youWon()
    }
}