import Foundation
import SpriteKit

class LevelBlockNode: BlockNode {
    static let SIZE = CGFloat(37.0)

    /// init
    init(parent: SKNode, y: Int, block: Block) {
        // init
        super.init(parent: parent, position: CGPoint(x: 0, y: 0), block: block, allowDelayedRender: false)

        self.zPosition = parent.zPosition + 1
        self.automaticSizeByTexture = false
        self.xScale = LevelBlockNode.SIZE / CGFloat(Block.Size.WIDTH)
        self.yScale = LevelBlockNode.SIZE / CGFloat(Block.Size.HEIGHT)

        let decimal = block.position.matrixAccuracy.y - floor(block.position.matrixAccuracy.y)
        self.position.x = -185.5 + block.position.nodeByDefaultSize(Int(LevelBlockNode.SIZE), height: Int(LevelBlockNode.SIZE)).x
        self.position.y = -259.0 + CGFloat(y) * LevelBlockNode.SIZE + CGFloat(decimal)
    }

    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    /// setup events
    override internal func setupEvents() -> BlockNode {
        return self
    }

    /// setup attributes
    override internal func setupAttributes() -> BlockNode {
        // gunner
        if (self.block.isGunner == true) {
            _ = BlockGunnerNode(parent: self, presentationMode: true)
        }

        // is color switcher
        if (self.block.countOfColorSwitch > 0) {
            self.colorSwitcherNode = BockColorSwitchNode(parent: self, presentationMode: true)
        }

        return self
    }

    /// setup physics
    override internal func setupPhysics() -> BlockNode {
        return self
    }

    /// setup debug
    override internal func setupDebug() -> BlockNode {
        return self
    }
}