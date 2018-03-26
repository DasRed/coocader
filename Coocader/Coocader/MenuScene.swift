import SpriteKit

class MenuScene: BaseScene {
    
    // button no ad
    private var buttonNoAd: ButtonNode?
    
    // all buttons
    private var buttons: [ButtonNode]! = []

    // store handler
    private var store: Store! = Store.shared

    // in view
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        // setting event
        self.setting.addListener(Setting.EventType.AdEnabledHasChanged, self.settingOfAdEnabledHasChanged, self)

        // play menu music
        self.audioPlayer.playMusic(.Menu)

        let yDelta = (self.setting.adEnabled ? 0 : 1) * AdHandler.BANNER_HEIGHT

        // level mode button
        self.buttons.append(TextButtonNode(self, "Level Modus".localized, CGPoint(x: 375, y: 884 + yDelta), self.buttonLevelModeWasTouched))

        // endless play button
        self.buttons.append(TextButtonNode(self, "Endless Game".localized, CGPoint(x: 375, y: 734 + yDelta), self.buttonEndlessPlayWasTouched))

        // Game Center button
        self.buttons.append(TextButtonNode(self, "Game Center".localized, CGPoint(x: 375, y: 584 + yDelta), self.buttonGameCenterWasTouched))

        // no ad button
        self.buttonNoAd = TextButtonNode(self, "Werbung entfernen".localized, CGPoint(x: 375, y: 434 + yDelta), self.buttonNoAdWasTouched, .highlight)
        self.buttonNoAd!.hidden = !self.setting.adEnabled
        self.buttons.append(self.buttonNoAd!)

        // restore purchases
        self.buttons.append(TextButtonNode(self, "Einkäufe wiederherstellen".localized, CGPoint(x: 375, y: 309 + yDelta), self.buttonRestorePruchasesWasTouched, .unimpressive))

        // setting toggle button
        self.appendSettingButtons(false)
        self.buttons.append(self.musicToggle)
        self.buttons.append(self.soundToggle)
    }
    
    // off view
    override func willMoveFromView(view: SKView) {
        super.willMoveFromView(view)
        self.setting.removeListener(self)
    }

    // setting of ad enabled has changed event
    func settingOfAdEnabledHasChanged(event: Event) {
        if (self.buttonNoAd != nil) {
            self.buttonNoAd!.hidden = !self.setting.adEnabled
        }
        
        let yDelta = CGFloat((self.setting.adEnabled ? -1 : 1) * AdHandler.BANNER_HEIGHT)
        
        for button in self.buttons {
            button.position.y += yDelta
        }
    }
    
    // endless play button
    func buttonEndlessPlayWasTouched() {
        self.controller.sceneHandler.showDifficultySelect()
    }
    
    // level mode button
    func buttonLevelModeWasTouched() {
        self.controller.sceneHandler.showLevelPackSelectScene()
    }
    
    // game center button
    func buttonGameCenterWasTouched() {
        self.controller.gameCenter.showLeaderboard()
    }
    
    // no ad button
    func buttonNoAdWasTouched() {
        self.store.buy(Store.ProductIdentifier.RemoveAd)
    }
    
    // restore pruchases button
    func buttonRestorePruchasesWasTouched() {
        self.store.restoreAll()
    }
}
