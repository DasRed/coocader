import Foundation

extension SceneHandler {

    // shows the main menu
    func showMenu() -> SceneHandler {
        return self.updateCurrentScene(MenuScene)
    }
    
    // shows the endless play game
    func showEndlessPlay() -> SceneHandler {
        return self.updateCurrentScene(EndlessPlayScene)
    }

    // shows the endless play game
    func showLevelPlay(level: LevelPack.Level) -> SceneHandler {
        Setting.sharedSetting().lastSelectedLevels[level.levelPack.id] = level.id
        return self.updateCurrentScene(LevelPlayScene.self, data: level)
    }
    
    // shows the endless play game
    func showDifficultySelect() -> SceneHandler {
        return self.updateCurrentScene(DifficultySelectScene)
    }

    /// show dialog
    func showDialog(data: DialogScene.Data) -> DialogScene {
        return self.presentAsOverlay(DialogScene.self, data: data) as! DialogScene
    }

    /// shows the level pack select scene
    func showLevelPackSelectScene() -> SceneHandler {
        return self.updateCurrentScene(LevelPackSelectScene)
    }

    /// shows the level select scene
    func showLevelSelectScene(levelPack: LevelPack) -> SceneHandler {
        Setting.sharedSetting().lastSelectedLevelPack = levelPack
        return self.updateCurrentScene(LevelSelectScene.self, data: levelPack)
    }
}