import Foundation
import SpriteKit

class GiftDescriptionLabelNode: LabelNode {
    
    // start position
    static let POSITION_Y = CGFloat(440)

    // init with reward
    convenience init(parent: SKNode, reward: Block.Reward, value: Float? = nil) {
        var text: String = ("reward-" + reward.rawValue).localized
        
        if (value != nil) {
            text = ("reward-" + reward.rawValue + "-value").localized(value!)
        }
        
        self.init(text: text)

        self.position = CGPoint(x: parent.scene!.frame.size.width / 2, y: GiftDescriptionLabelNode.POSITION_Y)
        self.fontColor = UIColor.yellowColor()
        self.strokeColor = Setting.FONT_STROKE_COLOR
        self.fontSize = 40
        self.alpha = 0.0
        self.zPosition = ZPosition.GiftDescription.rawValue
        parent.scene!.addChild(self)
        
        let actionMove = SKAction.moveByX(0, y: 100, duration: 3.0)
        actionMove.timingMode = .EaseInEaseOut
        
        let actionIn = SKAction.fadeInWithDuration(1.5)
        actionIn.timingMode = .EaseInEaseOut

        let actionOut = SKAction.fadeOutWithDuration(1.5)
        actionOut.timingMode = .EaseInEaseOut
        
        self.runAction(SKAction.group([
            actionMove,
            SKAction.sequence([
                actionIn,
                actionOut
            ])
        ]), completion: {
            self.removeFromParent()
        })
    }
}