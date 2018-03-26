import UIKit

class GameViewController: UIViewController, EGCDelegate {
    
    // ad handler
    lazy var adHandler: AdHandler! = { return AdHandler(self.view) }()
    
    // sceneHandler
    lazy var sceneHandler: SceneHandler! = { return SceneHandler(controller: self) }()

    // loading overlay
    var loadingOverlay: LoadingOverlay! = LoadingOverlay.shared

    // game enter
    var gameCenter: GameCenter!

    // store handler
    private var store: Store! = Store.shared

    // view loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // create the levelPack handler which does load all levels and so for preloading
        LevelPackHandler.shared

        // init gamecenter
        self.gameCenter = GameCenter(controller: self)

        // add generic listeners to store
        self.store.addListeners([
            Store.EventType.InteractionStarted: {(event: Event) in self.loadingOverlay.showOverlay(self.view!) },
            Store.EventType.InteractionEnded: {(event: Event) in self.loadingOverlay.hideOverlayView() },
            Store.EventType.ProductWasRestored: {(event: Event) in
                /// test identifer
                guard let identifier = event.data as? String else {
                    return
                }

                /// test if identifer is level pack identifer
                if (identifier.hasPrefix("levelpack.") == true) {
                    // find levelpack
                    let levelPackId = identifier.stringByReplacingOccurrencesOfString("levelpack.", withString: "")
                    let levelPack = LevelPackHandler.shared.levelPacks[levelPackId]

                    /// mark this levelpack as buyed
                    if (levelPack != nil) {
                        levelPack!.markAsBuyed()
                    }
                }

                /// test identifier for timeLimitEndlessMode
                if (identifier == Store.ProductIdentifier.TimeLimitEndlessGame.rawValue) {
                    Setting.sharedSetting().timeLimitOfEndlessModeEnabled = false
                }
            }
        ])

        // ad banner
        self.adHandler.appendBanner()

        // starts with the menu
        self.sceneHandler.showMenu()

        Block.TextureConfig.sharedTextureConfig().preload()
    }

    // auto rotater
    override func shouldAutorotate() -> Bool { return UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait }
   
    // supported interface orientations
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask { return [UIInterfaceOrientationMask.Portrait] }

    // status bar hidden?
    override func prefersStatusBarHidden() -> Bool { return true }
}
