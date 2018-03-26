import Foundation
import SpriteKit

class LevelPackSelectScene: BaseScene {

    /// x delta for nodes
    static let POSITION_X_DELTA = 500

    /// the level pack handler
    lazy private(set) var levelPackHandler: LevelPackHandler = {
        return LevelPackHandler.shared
    }()

    /* point of touch location start */
    private var touchLocationX: CGFloat! = 0.0

    /// all level pack nodes
    internal var levelPackNodes: [SKNode] = []

    /// container of entries
    internal var levelPackContainer: SKNode!

    /// current entry index
    internal var entryIndexSelected: Int = 0

    /// container is moveable
    private var isMovable: Bool = true

    /// did move to view
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        // play menu music
        self.audioPlayer.playMusic(.Menu)

        self.appendSettingButtons(true)

        self.levelPackContainer = SKNode()
        self.levelPackContainer.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(self.levelPackContainer)

        self.createNodes()
    }

    /// create the nodes
    func createNodes() {
        let levelPacks = self.levelPackHandler.sorted()

        if (self.setting.lastSelectedLevelPack != nil) {
            for (index, levelPack) in levelPacks.enumerate() {
                if (levelPack === self.setting.lastSelectedLevelPack) {
                    self.entryIndexSelected = index
                }
            }
        }

        self.levelPackContainer.position.x += CGFloat(-1 * LevelPackSelectScene.POSITION_X_DELTA * self.entryIndexSelected)

        // render the levelpacks
        for (index, levelPack) in levelPacks.enumerate() {
            let renderIt = (index == self.entryIndexSelected - 1) || (index == self.entryIndexSelected) || (index == self.entryIndexSelected + 1)
            let node = LevelPackNode(parent: self.levelPackContainer, levelPack: levelPack, delayedRender: !renderIt)
            node.position.x = CGFloat(index * LevelPackSelectScene.POSITION_X_DELTA)

            // play was pressed
            node.addListener(LevelPackNode.EventType.Play, {(event: Event) in
                let levelPack = event.data as! LevelPack
                self.controller.sceneHandler.showLevelSelectScene(levelPack)
            }, self)

            self.levelPackNodes.append(node)
        }
    }

    /// will move from view
    override func willMoveFromView(view: SKView) {
        for node in self.levelPackNodes {
            (node as! EventManagerProtocol).removeListener(self)
        }
    }

    // touches began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchLocationX = touches.first!.locationInNode(self).x
    }

    // touches move
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocationCurrentX = touches.first!.locationInNode(self).x
        let delta = touchLocationCurrentX - self.touchLocationX

        guard delta != 0 else {
            return
        }
        
        self.touchLocationX = touchLocationCurrentX

        if (delta < 0 && self.entryIndexSelected == self.levelPackNodes.count - 1) {
            return
        }
        else if (delta > 0 && self.entryIndexSelected == 0) {
            return
        }

        guard self.isMovable == true else {
            return
        }

        self.isMovable = false
        self.entryIndexSelected += delta < 0 ? 1 : -1
        self.levelPackContainer.runAction(SKAction.moveByX(CGFloat((delta < 0 ? -1 : 1) * LevelPackSelectScene.POSITION_X_DELTA), y: 0, duration: 0.125))
    }

    /// touch move ends
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.isMovable = true
    }

    /// on menu toggle
    override func onMenuToggle() {
        self.controller.sceneHandler.showMenu()
    }
}