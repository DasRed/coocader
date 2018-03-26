import Foundation
import SpriteKit

class BigStarsNode: SKNode {

    /// init
    init(parent: SKNode, difficulty: Float) {
        super.init()
        
        self.userInteractionEnabled = false

        parent.addChild(self)

        // create the stars
        var starNode: SpriteNode
        var type: String

        for var i = 1; i <= 5; i++ {
            type = "0"
            if (Float(i) > difficulty) {
                type = "2"
            }
            if (Float(i) + 0.5 == difficulty) {
                type = "1"
            }

            starNode = SpriteNode(parent: self, texture: "difficulty/type-0/" + type, atlas: .Level)
            starNode.position.x = CGFloat(60 * (i - 3))
        }
    }

    /// hmpf usless...
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}