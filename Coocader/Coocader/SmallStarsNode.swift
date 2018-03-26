import Foundation
import SpriteKit

class SmallStarsNode: SpriteNode {

    /// init
    init(parent: SKNode, difficulty: GameSetting.Difficulty) {
        super.init(parent: parent, texture: "difficulty/type-1/" + difficulty.rawValue, atlas: .Level)

        self.userInteractionEnabled = false
    }

    /// hmpf usless...
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}