import Foundation
import SpriteKit

extension GameSetting {
    class Gift: GameSettingSetting {
        
        // delta of moving down
        lazy var impulse: CGFloat = {
            switch self.game.difficulty {
            case .ScaredyCat:   return  0.00000
            case .Simple:       return -0.00005
            case .Normal:       return -0.00010
            case .Hard:         return -0.00050
            case .Extrem:       return -0.00100
            }
        }()
    }
}