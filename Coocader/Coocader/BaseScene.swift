import Foundation
import SpriteKit

class BaseScene: SKScene {
    
    // the controller
    var controller: GameViewController!

    // audio player
    internal var audioPlayer: AudioPlayer! = AudioPlayer.shared

    // setting instance
    internal var setting: Setting! = Setting.sharedSetting()

    // the screen
    lazy var screen: UIScreen = UIScreen.mainScreen()

    // the background node
    lazy var backgroundNode: BackgroundNode = { return BackgroundNode(parent: self) }()

    // music toggle button
    internal var musicToggle: ToggleIconButtonNode!

    // music toggle button
    internal var soundToggle: ToggleIconButtonNode!

    // music toggle button
    internal var menuToggle: IconButtonNode!

    /// set data
    func setData(data: Any) {
        fatalError("setData must be overloaded")
    }

    // starts everything
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.scaleMode = .AspectFill
        self.size.width = view.frame.size.width * self.screen.scale
        self.size.height = view.frame.size.height * self.screen.scale

        self.size.width = 750.0
        self.size.height = 1334.0

        let xScale = CGFloat(view.frame.size.width * self.screen.scale / self.size.width)
        if (xScale != 1.0) {
            self.scaleMode = .Fill
            //self.xScale = xScale
        }
        let yScale = CGFloat(view.frame.size.height * self.screen.scale / self.size.height)
        if (yScale != 1.0) {
            self.scaleMode = .Fill
            //self.yScale = yScale
        }

        // creates the background node
        _ = self.backgroundNode
        
        #if DEBUG
            _ = DebugNode(scene: self)
        #endif
    }

    /// appends the settings buttons to scene
    func appendSettingButtons(hasMenu: Bool = true) {
        // y for buttons
        let y = self.size.height - 50.0 - CGFloat(self.setting.adEnabled ? AdHandler.BANNER_HEIGHT : 0)

        // menu button
        if (hasMenu == true) {
            self.menuToggle = IconButtonNode(self, "menu", CGPoint(x: 100, y: y), self.onMenuToggle)
        }

        // music toggle button
        self.musicToggle = ToggleIconButtonNode(self, "music", CGPoint(x: 650, y: y), {
            self.setting.musicEnabled = !self.setting.musicEnabled
        })
        self.musicToggle.enabled = self.setting.musicEnabled ? .On : .Off

        // sound toggle button
        self.soundToggle = ToggleIconButtonNode(self, "sound", CGPoint(x: 580, y: y), {
            self.setting.soundEnabled = !self.setting.soundEnabled
        })
        self.soundToggle.enabled = self.setting.soundEnabled ? .On : .Off
    }

    func onMenuToggle() {
         fatalError("Function onMenuToggle must be overwritten")
    }
}
