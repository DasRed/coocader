import Foundation
import SpriteKit

extension ColorSelectorButtonNode {
    internal class Sprite: GameButtonNode {
        
        // move during touch
        private var hasMoved: Bool! = false
        private var touchLocationY: CGFloat! = 0.0
        
        // init
        init(parent: ColorSelectorButtonNode, side: GameButtonNode.Side) {
            super.init(parent: parent, side: side, overlayImage: "color-selector/" + parent.selectedColor.rawValue)
        }
        
        // init
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        
        /// touches began
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            guard self.scene!.paused == false else {
                return
            }

            self.switchToNextColor()
        }
        
        /// switches the color to the next in line by using the side as direction
        func switchToNextColor(var direction: GameButtonNode.Side? = nil) {
            let selector = self.parent as! ColorSelectorButtonNode
            var colors = Block.Color.all()
            var doNextColor = false
            
            if (direction == nil) {
                direction = self.side
            }
            
            if (direction! == .Right) {
                colors = colors.reverse()
            }
            
            for color in colors {
                if (doNextColor == true) {
                    selector.selectedColor = color
                    return
                }
                
                doNextColor = (color == selector.selectedColor)
            }
            
            selector.selectedColor = colors.first!
        }
    }
}