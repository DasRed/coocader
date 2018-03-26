import Foundation
import SpriteKit

enum ZPosition: CGFloat {
    case Background = 0

    case Level

    case Matrix
    case Explosion

    case Deathline
    case Defender

    case Shot
    case ShotExplosion

    case GiftDescription

    case GameControls
    case GameHeader

    case Buttons
    
    #if DEBUG
    case Debug
    #endif
}