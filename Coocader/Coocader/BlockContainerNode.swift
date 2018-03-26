
import Foundation
import SpriteKit

class BlockContainerNode: SKNode {
    
    // init
    init(parent: SKNode, initialPositionY: Int? = nil) {
        super.init()
        parent.addChild(self)
        
        self.position = CGPoint(x: 100, y: initialPositionY != nil ? initialPositionY! : GameSetting.shared.blockContainer.initialPositionY)
        self.userInteractionEnabled = false
        self.zPosition = ZPosition.Matrix.rawValue
        
        // start the move down animation
        self.runMovingAction()
        
        // Rewards
        EventManager.sharedEventManager().addListener(GiftNode.EventType.RewardToGive, {(event: Event) in
            let reward = event.data as! Block.Reward
            switch reward {
            case .IncreaseBlockContainerMovingWaitingDuration:
                // increase block container moving waiting duration
                GameSetting.shared.blockContainer.movingWaitingDuration.offset += GameSetting.shared.reward.increaseBlockContainerMovingWaitingDuration.calc()
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                break
                
            case .DecreaseBlockContainerMovingWaitingDuration:
                // decrease block container moving waiting duration
                GameSetting.shared.blockContainer.movingWaitingDuration.offset -= GameSetting.shared.reward.decreaseBlockContainerMovingWaitingDuration.calc()
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                break

            case .IncreaseBlockContainerMovingDeltaDuration:
                // increase block container moving delta duration
                GameSetting.shared.blockContainer.movingDeltaDuration.offset += GameSetting.shared.reward.increaseBlockContainerMovingDeltaDuration.calc()
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                break

            case .DecreaseBlockContainerMovingDeltaDuration:
                // decrease block container moving delta duration
                GameSetting.shared.blockContainer.movingDeltaDuration.offset -= GameSetting.shared.reward.decreaseBlockContainerMovingDeltaDuration.calc()
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                break
                
            case .IncreaseBlockContainerPositionY:
                // sound
                AudioPlayer.shared.playSound(.RewardForIncreaseBlockContainerPositionY)

                // move block position
                let action = SKAction.moveByX(0, y: CGFloat(GameSetting.shared.reward.increaseBlockContainerPositionY.calc() as! Float), duration: 0.5)
                action.timingMode = .EaseInEaseOut
                self.runAction(action, completion: {
                    guard let scene = self.scene as? PlayScene else {
                        return
                    }
                    
                    scene.testAndMoveBlocksIntoView()
                })
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                break

            case .DecreaseBlockContainerPositionY:
                // sound
                AudioPlayer.shared.playSound(.RewardForIncreaseBlockContainerPositionY)

                // move block position
                let action = SKAction.moveByX(0, y: -1.0 * CGFloat(GameSetting.shared.reward.decreaseBlockContainerPositionY.calc() as! Float), duration: 0.5)
                action.timingMode = .EaseInEaseOut
                self.runAction(action)
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                break
                
            default:
                return
            }
        }, self)
    }
    
    // destruct
    deinit {
        EventManager.sharedEventManager().removeListener(self)
    }

    // pfff
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // runs the moving action
    func runMovingAction() {
        let movingDeltaY = GameSetting.shared.blockContainer.movingDeltaY.calc()
        let movingDeltaDuration = GameSetting.shared.blockContainer.movingDeltaDuration.calc()
        let movingWaitingDuration = GameSetting.shared.blockContainer.movingWaitingDuration.calc()

        // the moving action
        let actionMove = SKAction.moveByX(0, y: CGFloat(movingDeltaY), duration: NSTimeInterval(movingDeltaDuration))
        actionMove.timingMode = .EaseIn
        
        // action wait
        let actionWait = SKAction.waitForDuration(NSTimeInterval(movingWaitingDuration))
        
        // run the actions and after run, recreate the actions
        self.runAction(SKAction.sequence([actionWait, actionMove]), completion: self.runMovingAction)
    }
}