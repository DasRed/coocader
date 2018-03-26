import Foundation
import SpriteKit

class BackgroundNode: SpriteNode {
    
    // init
    convenience init(parent: SKNode) {
        self.init(parent: parent, texture: SKTexture(imageNamed: "background"))
        
        self.automaticSizeByTexture = false
        self.userInteractionEnabled = false

        self.position.x = CGRectGetMidX(parent.frame)
        self.position.y = CGRectGetMidY(parent.frame)
        self.size = parent.frame.size
        self.zPosition = ZPosition.Background.rawValue
    }
}