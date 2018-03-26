import Foundation
import SpriteKit

class BlockNode: SpriteNode {

    // events
    enum EventType: String, EventTypeProtocol {
        case BlockWasDestroyedByShot = "game.block.wasDestroyedByShot" // data contains the block
    }
    
    // the current block
    let block: Block!
    
    // colorSitcherNode
    var colorSwitcherNode: BockColorSwitchNode?

    /// the gunner node
    private var gunnerNode: BlockGunnerNode?

    // construct
    init(parent: SKNode, position: CGPoint, block: Block, allowDelayedRender: Bool = true) {
        self.block = block

        super.init(parent: parent)

        // self
        self.position = position
        self.size.width = CGFloat(Block.Size.WIDTH)
        self.size.height = CGFloat(Block.Size.HEIGHT)

        if (allowDelayedRender == false || self.scene!.intersectsNode(self) == true) {
            self.setup()
        }
        else {
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(1.random(5))),
                SKAction.runBlock(self.setup)
            ]))
        }
    }
    
    /// setup the block
    internal func setup() {
        self.zPosition = ZPosition.Matrix.rawValue
        self.texture = self.block.texture()

        self.setupEvents().setupAttributes().setupPhysics().setupAction().setupDebug()
    }

    /// setup events
    internal func setupEvents() -> BlockNode {
        // listing to block events
        self.block.addListeners([
            // color switches on this node
            Block.EventType.SwitchedHisColor: {
                self.texture = self.block.texture()
                self.removeAllActions()
                self.runAction(self.block.animationForAction())
            },
            
            // is no longer color switcher
            Block.EventType.DisabledColorSwitching: {
                if (self.block.countOfColorSwitch == 0 && self.colorSwitcherNode != nil) {
                    self.colorSwitcherNode!.removeFromParent()
                    self.colorSwitcherNode = nil
                }
            }
        ], self)

        return self
    }

    /// setup attributes
    internal func setupAttributes() -> BlockNode {
        // gunner
        if (self.block.isGunner == true) {
            self.gunnerNode = BlockGunnerNode(parent: self)
        }
        
        // is color switcher
        if (self.block.countOfColorSwitch > 0) {
            self.colorSwitcherNode = BockColorSwitchNode(parent: self)
        }

        return self
    }

    /// setup physics
    internal func setupPhysics() -> BlockNode {
        // physics body
        let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.dynamic = false
        physicsBody.pinned = true
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = CategoryBitMask.Block.rawValue
        physicsBody.collisionBitMask = CategoryBitMask.Shot.rawValue | CategoryBitMask.Deathline.rawValue | CategoryBitMask.Block.rawValue
        physicsBody.contactTestBitMask = CategoryBitMask.Shot.rawValue | CategoryBitMask.Deathline.rawValue | CategoryBitMask.Block.rawValue
        self.physicsBody = physicsBody

        return self
    }

    /// setup Action
    internal func setupAction() -> BlockNode {
        // run the animation
        self.runAction(self.block.animationForAction())

        return self
    }

    /// setup debug
    internal func setupDebug() -> BlockNode {
        // is giver
        #if DEBUG
            if (self.block.reward != nil) {
                let border = SKShapeNode(rect: CGRect(
                    x: -self.size.width / 2 + 3,
                    y: -self.size.height / 2 + 3,
                    width: self.size.width - 8,
                    height: self.size.height - 8
                ))
                border.strokeColor = UIColor.yellowColor()
                border.lineWidth = 3
                border.userInteractionEnabled = false
                border.hidden = true
                self.addChild(border)
                EventManager.sharedEventManager().addListener(DebugNode.EventType.ToggleGiftNodes, {
                    border.hidden = !border.hidden
                })
            }
        #endif

        return self
    }
    
    // deinit
    deinit {
        self.block.removeListener(self)
        #if DEBUG
            EventManager.sharedEventManager().removeListener(self)
        #endif
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        self.block = Block()
        
        super.init(coder: aDecoder)
    }

    // destroyed by a shot
    func destroyByShot(completion: () -> Void) {
        // drop the gift
        if (self.block.reward != nil) {
            _ = GiftNode(blockNode: self)
        }

        if (self.gunnerNode != nil) {
            self.gunnerNode!.removeFromParent()
        }

        _ = ExplosionNode(parent: self, completion: {
            self.destroy()
            completion()
        })
    }

    // destroyed by deathline
    func destroyByDeathline(completion: () -> Void) {
        self.destroyByShot(completion)
    }
    
    // remove from parent
    func destroy() {
        self.block.node = nil
        self.removeFromParent()
    }
}

extension Block {
    
    // creates a block node
    func createNode(container: BlockContainerNode) -> BlockNode {
        let blockNode = BlockNode(parent: container, position: self.position.node, block: self)
        
        self.node = blockNode
        blockNode.zPosition = ZPosition.Matrix.rawValue

        return blockNode
    }
}