import Foundation
import SpriteKit

class ColorSelectorButtonNode: SKNode, EventManagerProtocol {
    
    // events
    enum EventType: String, EventTypeProtocol {
        case ColorChanged = "game.colorSelector.colorChanged" // data is type of Block.Color
    }
    
    // current color
    internal(set) var selectedColor: Block.Color! {
        didSet {
            if (self.selectedColor != .Spectral) {
                self.selectorLeft.overlayImage.texture = self.selectorLeft.textureAtlas("color-selector/" + self.selectedColor.rawValue)
                self.selectorRight.overlayImage.texture = self.selectorRight.textureAtlas("color-selector/" + self.selectedColor.rawValue)
            }
            
            // Spectral is selected
            if (oldValue != .Spectral && self.selectedColor == .Spectral) {
                self.selectorLeft.userInteractionEnabled = false
                self.selectorRight.userInteractionEnabled = false
                
                self.runAction(SKAction.fadeOutWithDuration(0.5))
            }
            // Spectral was selected
            else if (oldValue == .Spectral && self.selectedColor != .Spectral) {
                self.selectorLeft.userInteractionEnabled = true
                self.selectorRight.userInteractionEnabled = true
                
                self.runAction(SKAction.fadeInWithDuration(0.5))
            }
            
            self.trigger(EventType.ColorChanged, self.selectedColor)
        }
    }
    
    // selector left
    private var selectorLeft: ColorSelectorButtonNode.Sprite!
    
    // selector right
    private var selectorRight: ColorSelectorButtonNode.Sprite!
    
    // init
    init(parent: SKNode, selectedColor: Block.Color) {
        self.selectedColor = selectedColor
        
        super.init()
        
        self.position.x = 0
        self.position.y = 0
        
        parent.addChild(self)
        
        self.selectorLeft = Sprite(parent: self, side: .Left)
        self.selectorRight = Sprite(parent: self, side: .Right)
        
        // reward
        var colorPrevious: Block.Color = self.selectedColor
        EventManager.sharedEventManager().addListener(GiftNode.EventType.RewardToGive, {(event: Event) in
            let reward = event.data as! Block.Reward
            
            if (reward != .ShipShotsSpectral) {
                return
            }
            
            if (self.selectedColor == .Spectral) {
                _ = GiftDescriptionLabelNode(parent: self, reward: reward)
                return
            }
            
            colorPrevious = self.selectedColor
            self.selectedColor = .Spectral
            
            let duration = GameSetting.shared.reward.shipShotsSpectral.calc()
            
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(NSTimeInterval(duration)),
                SKAction.runBlock({
                    self.selectedColor = colorPrevious
                })
            ]))
            
            _ = GiftDescriptionLabelNode(parent: self, reward: reward, value: duration)
        }, self)
    }
    
    // deinit
    deinit {
        EventManager.sharedEventManager().removeListener(self)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}