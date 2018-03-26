import Foundation
import SpriteKit

extension Block {
    
    enum Color: String, BlockTypeEnumProtocol {
        case Green = "0"
        case Purple = "1"
        case Pink = "2"
        case Red = "3"
        case Yellow = "4"
        case Blue = "5"
        case Orange = "6"
        case Black = "7"
        case Spectral = "8"

        /// creates
        static func create(value: Int?) -> Color? {
            guard value != nil else {
                return nil
            }

            guard let result = Color(rawValue: String(value!)) else {
                return nil
            }

            return result
        }

        // all
        static func all() -> [Color] {
            return [.Green, .Purple, .Pink, .Red, .Yellow, .Blue, .Orange, .Black]
        }
        
        // weight of face during creation
        static func weightingsOfCreation() -> [Range <Int>] {
            return [
                1...5, // Green
                6...10, // Purple
                11...15, // Pink
                16...20, // Red
                21...25, // Yellow
                26...30, // Blue
                31...35, // Orange
                36...40 // Black
            ]
        }
        
        // color to int
        func toInt() -> Int {
            return Int(self.rawValue)!
        }
        
        // color in UIColor
        func color() -> UIColor {
            switch self {
            case .Black: return UIColor.darkGrayColor()
            case .Blue: return UIColor.blueColor()
            case .Green: return UIColor.greenColor()
            case .Orange: return UIColor.orangeColor()
            case .Pink: return UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0)
            case .Purple: return UIColor.purpleColor()
            case .Red: return UIColor.redColor()
            case .Yellow: return UIColor.yellowColor()
            case .Spectral: return UIColor.whiteColor()
            }
        }
    }
}