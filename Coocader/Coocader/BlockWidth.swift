import Foundation

extension Block {

    enum Width: String, BlockTypeEnumProtocol {
        case Once = "0"
        case Double = "1"
        case Triple = "2"
        case Quadruple = "3"
        case Fivefold = "4"

        /// creates
        static func create(value: Int?) -> Width? {
            guard value != nil else {
                return nil
            }

            guard let result = Width(rawValue: String(value!)) else {
                return nil
            }

            return result
        }

        // all
        static func all() -> [Width] {
            return [.Once, .Double, .Triple, .Quadruple, .Fivefold]
        }
        
        // weight of width during creation
        static func weightingsOfCreation() -> [Range <Int>] {
            return [
                0...81, // Width.Once
                81...92, // Width.Double
                92...98, // Width.Triple 5%
                98...100, // Width.Quadruple 2%
                100...100 // Width.Fivefold 1%
            ]
        }
        
        // color to int
        func toInt() -> Int {
            return Int(self.rawValue)!
        }
    }
}