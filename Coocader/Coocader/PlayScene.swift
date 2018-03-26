import SpriteKit

class PlayScene: BaseScene, SKPhysicsContactDelegate {


    // the game matrix
    internal var matrix: Matrix! = Matrix()

    // container node
    lazy internal var containerNode: BlockContainerNode = {
        return BlockContainerNode(parent: self)
    }()

    // header
    internal var gameHeaderNode: GameHeaderNode!

    // points
    var points: Int = 0
    
    // in view
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.startTheGame()
    }
    
    // starts the game
    func startTheGame() {
        // music
        switch GameSetting.shared.difficulty {
        case .ScaredyCat:
            self.audioPlayer.playMusic(.GameModeScaredyCat)
            break

        case .Simple:
            self.audioPlayer.playMusic(.GameModeSimple)
            break

        case .Normal:
            self.audioPlayer.playMusic(.GameModeNormal)
            break

        case .Hard:
            self.audioPlayer.playMusic(.GameModeHard)
            break

        case .Extrem:
            self.audioPlayer.playMusic(.GameModeExtrem)
            break
        }

        /// stuff
        self.createPhysicsWorld()
        self.appendSettingButtons(true)
        self.createGameHeader()
        self.createControls()
        self.createBlocks()

        // listen to the matrix
        self.matrix.addListener(Matrix.EventType.LineWasRemoved, self.matrixHasRemovedALine, self)
        self.matrix.addListener(Matrix.EventType.BlockWasAppend, self.matrixHasAppendABlock, self)

        // reward
        EventManager.sharedEventManager().addListeners([
            GiftNode.EventType.RewardToGive: {(event: Event) in
                let reward = event.data as! Block.Reward
                if (reward == .DestroyFirstLineInMatrix) {
                    self.destroyFirstLineOfBlocks()
                    _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                }
            },
            GiftNode.EventType.ShipWasDestroyed: {(event: Event) in
                self.youLoose()
            }
        ], self)
    }

    /// creates the game header
    func createGameHeader() {
        self.gameHeaderNode = GameHeaderNode(parent: self)
    }

    /// creates the physics world
    func createPhysicsWorld() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, -1.0)
    }

    /// create the control with deathline and ship
    func createControls() {
        // controls
        let colorSelectorButtonNode = ColorSelectorButtonNode(parent: self, selectedColor: Block.Color.Green)

        // ship
        let defenderZone = DefenderZoneNode(parent: self)
        _ = DeathlineNode(parent: defenderZone)
        _ = ShipNode(
            parent: defenderZone,
            colorSelectorNode: colorSelectorButtonNode
        )
    }

    /// create all blocks
    func createBlocks() {
        // create the block nodes
        for blocksInLine in self.matrix.blocks.values {
            for block in blocksInLine.values {
                block.createNode(self.containerNode)
            }
        }
    }

    // disappear
    override func willMoveFromView(view: SKView) {
        EventManager.sharedEventManager().removeListener(self)
        self.matrix.removeListener(self)
    }
    
    // a block was append by the matrix
    func matrixHasAppendABlock(event: Event) {
        guard let block = event.data as? Block else {
            return
        }
        
        block.createNode(self.containerNode)
    }
    
    // matrix has removed a line
    func matrixHasRemovedALine() {
        // has still blocks
        if (self.matrix.blocks.count != 0) {
            self.testAndMoveBlocksIntoView()
            return
        }

        // has no lines an no blocks anymore
        self.youWon()
    }
    
    // physic contact
    func didBeginContact(contact: SKPhysicsContact) {
        guard self.paused == false else {
            return
        }

        var blockNode: BlockNode?
        var shotNode: ShotNode?
        var deathlineNode: DeathlineNode?
        var shipNode: ShipNode?
        var gunnerShotNode: GunnerShotNode?
        var giftNode: GiftNode?

        // convert body A
        switch contact.bodyA.categoryBitMask {
        case CategoryBitMask.Block.rawValue:
            blockNode = contact.bodyA.node as? BlockNode
            break
            
        case CategoryBitMask.Shot.rawValue:
            shotNode = contact.bodyA.node as? ShotNode
            break
            
        case CategoryBitMask.Deathline.rawValue:
            deathlineNode = contact.bodyA.node as? DeathlineNode
            break
            
        case CategoryBitMask.Ship.rawValue:
            shipNode = contact.bodyA.node as? ShipNode
            break
            
        case CategoryBitMask.GunnerShot.rawValue:
            gunnerShotNode = contact.bodyA.node as? GunnerShotNode
            break
            
        case CategoryBitMask.Gift.rawValue:
            giftNode = contact.bodyA.node as? GiftNode
            break

        default: return
        }
        
        // convert b0dy b
        switch contact.bodyB.categoryBitMask {
        case CategoryBitMask.Block.rawValue:
            blockNode = contact.bodyB.node as? BlockNode
            break
            
        case CategoryBitMask.Shot.rawValue:
            shotNode = contact.bodyB.node as? ShotNode
            break
            
        case CategoryBitMask.Deathline.rawValue:
            deathlineNode = contact.bodyB.node as? DeathlineNode
            break
            
        case CategoryBitMask.Ship.rawValue:
            shipNode = contact.bodyB.node as? ShipNode
            break
            
        case CategoryBitMask.GunnerShot.rawValue:
            gunnerShotNode = contact.bodyB.node as? GunnerShotNode
            break
            
        case CategoryBitMask.Gift.rawValue:
            giftNode = contact.bodyB.node as? GiftNode
            break
        
        default: return
        }
                
        // block && shot
        if (blockNode != nil && shotNode != nil) {
            self.didBeginContactBetweenBlockAndShot(blockNode!, shotNode: shotNode!)
        }
        
        // block && defenderZone
        if (blockNode != nil && deathlineNode != nil) {
            self.didBeginContactBetweenBlockAndDefenderZone(blockNode!, deathlineNode: deathlineNode!)
        }
        
        // gunner shot and ship
        if (gunnerShotNode != nil && shipNode != nil) {
            self.didBeginContactBetweenGunnerShotAndShip(gunnerShotNode!, shipNode: shipNode!)
        }
        
        // gunner shot and ship
        if (gunnerShotNode != nil && shotNode != nil) {
            self.didBeginContactBetweenGunnerShotAndShot(gunnerShotNode!, shotNode: shotNode!)
        }
        
        // gift and ship
        if (giftNode != nil && shipNode != nil) {
            self.didBeginContactBetweenGiftAndShip(giftNode!, shipNode: shipNode!)
        }
    }
    
    /// ship and gift hits
    private func didBeginContactBetweenGiftAndShip(giftNode: GiftNode, shipNode: ShipNode) {
        giftNode.destroyByHit()
    }
    
    // gunner shot and ship
    private func didBeginContactBetweenGunnerShotAndShot(gunnerShotNode: GunnerShotNode, shotNode: ShotNode) {
        // hit... not
        if (gunnerShotNode.shotColor != shotNode.shotColor) {
            return
        }
        
        // hitz... destroy both shots
        gunnerShotNode.destroyByHit()
        shotNode.destroy()
    }
    
    // gunner shot and ship
    private func didBeginContactBetweenGunnerShotAndShip(gunnerShotNode: GunnerShotNode, shipNode: ShipNode) {
        // hit... not
        if (gunnerShotNode.shotColor != shipNode.selectedColor) {
            gunnerShotNode.destroyByMiss()
            return
        }
        
        // loose
        self.youLoose()
    }

    // block and shot contact
    private func didBeginContactBetweenBlockAndShot(blockNode: BlockNode, shotNode: ShotNode) {
        // not the same color and not a spectral shot... destroy the missle
        if (shotNode.shotColor != .Spectral && blockNode.block.color != shotNode.shotColor) {
            shotNode.destroyByMiss()
            return
        }

        // block is color switcher
        if (blockNode.block.countOfColorSwitch > 0) {
            shotNode.destroyByHit()
            blockNode.block.switchColor()
            return
        }

        // correct hit of shot... destroy block and shot
        self.points += blockNode.block.points
        shotNode.destroy()
        blockNode.destroyByShot({
            self.matrix.removeBlock(blockNode.block)
        })
    }

    // deathline and block has contact
    private func didBeginContactBetweenBlockAndDefenderZone(blockNode: BlockNode, deathlineNode: DeathlineNode) {
        switch deathlineNode.deathType {
            
        case .ForBlocks:
            self.destroyFirstLineOfBlocks()
            break
        
        case .ForUser:
            self.youLoose()
            
            break
        }
    }
    
    /// destroys the first line of blocks in the matrix
    private func destroyFirstLineOfBlocks() {
        let firstLine = self.matrix.blocks.keys.minElement()!
        
        for block in self.matrix.blocks[firstLine]!.values {
            if (block.node != nil) {
                self.points += block.points
                block.node!.destroyByDeathline({
                    self.matrix.removeBlock(block)
                })
            }
        }
    }
    
    /// tests if all blocks into visible area
    func testAndMoveBlocksIntoView() {
        let firstLine = self.matrix.blocks.keys.minElement()!

        let block = self.matrix.blocks[firstLine]!.first!.1
        guard let blockNode = block.node else {
            return
        }
        
        let blockY = blockNode.position.y + (blockNode.size.height / 2) + self.containerNode.position.y
        let headerY = self.gameHeaderNode.position.y - self.gameHeaderNode.size.height / 2
        if (blockY > headerY) {
            self.containerNode.runAction(SKAction.moveByX(0, y: headerY - (blockY + 3.0 * blockNode.size.height), duration: 0.2))
        }
    }

    /// the game was lost
    func youLoose() {
        self.controller.adHandler.showInterstitial()
    }

    /// the game was won
    func youWon() {
        self.controller.adHandler.showInterstitial()
    }

    /// on menu toggle pressed
    override func onMenuToggle() {
        var data = DialogScene.Data()
        data.onYes = {
            self.controller.adHandler.showInterstitial({
                self.controller.sceneHandler.showMenu()
            })
        }
        data.onNo = { self.paused = false  }
        data.textA = "Möchtest du wirklich aufhören zu spielen?".localized
        data.textB = "Deine Punkte werden nicht gespeichert!".localized

        self.controller.sceneHandler.showDialog(data)
    }
}