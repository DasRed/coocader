import SpriteKit

class EndlessPlayScene: PlayScene {
    
    // init lines
    static let INITIAL_LINES = 25

    // points
    override var points: Int {
        didSet {
            self.gameHeaderNode.labelValue.text = String(self.points)
        }
    }

    // in view
    override func startTheGame() {
        // create all blocks
        self.matrix.createAndAppendLines(countOfLines: EndlessPlayScene.INITIAL_LINES)
        super.startTheGame()

        if (self.setting.timeLimitOfEndlessModeEnabled == true) {
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(60),
                SKAction.runBlock(self.showTimeLimit)
            ]))
        }
    }
    
    // matrix has removed a line
    override func matrixHasRemovedALine() {
        self.testAndMoveBlocksIntoView()
        self.matrix.createAndAppendLine()
    }
    
    /// the game was lost
    override func youLoose() {
        self.controller.gameCenter.store(self.points, difficulty: GameSetting.shared.difficulty)

        var data = DialogScene.Data()
        data.onYes = { self.controller.sceneHandler.showEndlessPlay() } 
        data.onNo = { self.controller.sceneHandler.showMenu() }
        data.textA = "Du hast verloren!".localized

        self.controller.sceneHandler.showDialog(data)

        super.youLoose()
    }

    /// the game was won
    override func youWon() {
        self.controller.gameCenter.store(self.points, difficulty: GameSetting.shared.difficulty)

        var data = DialogScene.Data()
        data.onYes = { self.controller.sceneHandler.showEndlessPlay() } 
        data.onNo = { self.controller.sceneHandler.showMenu() }
        data.textA = "Du hast gewonnen!".localized

        self.controller.sceneHandler.showDialog(data)

        super.youWon()
    }

    /// shows the time limit
    func showTimeLimit() {
        guard self.setting.timeLimitOfEndlessModeEnabled == true else {
            return
        }

        var dialog: DialogScene!

        var data = DialogScene.Data()
        data.onYes = {
            Store.shared.buy(Store.ProductIdentifier.TimeLimitEndlessGame, completion: {
                self.setting.timeLimitOfEndlessModeEnabled = false
                dialog.removeDialog()
                self.paused = false
            })
        }
        data.onNo = self.youLoose

        data.textA = "Die Zeit ist abgelaufen.".localized
        data.textB = "Möchtest du ohne Zeitlimit weiterspielen?".localized

        data.textYes = "Kaufen".localized
        data.styleYes = .highlight
        data.removeOnYes = false

        data.textNo = "Spiel beenden".localized
        data.removeOnNo = true

        self.paused = true
        dialog = self.controller.sceneHandler.showDialog(data)
    }
}