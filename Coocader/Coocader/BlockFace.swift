import Foundation

extension Block {
    
    enum Face: String, BlockTypeEnumProtocol {
        case Masky = "0"
        case Evil = "1"
        case Sleepy = "2"
        case Hiddy = "3"
        case Dummy = "4"
        case Frighty = "5"
        case Sneaky = "6"
        case Annoyey = "7"

        /// creates
        static func create(value: Int?) -> Face? {
            guard value != nil else {
                return nil
            }

            guard let result = Face(rawValue: String(value!)) else {
                return nil
            }

            return result
        }

        // all
        static func all() -> [Face] {
            return [.Masky, .Evil, .Sleepy, .Hiddy, .Dummy, .Frighty, .Sneaky, .Annoyey]
        }
        
        // weight of face during creation
        static func weightingsOfCreation() -> [Range <Int>] {
            return [
                1...5, // Masky
                6...10, // Evil
                11...15, // Sleepy
                16...20, // Hiddy
                21...25, // Dummy
                26...30, // Frighty
                31...35, // Sneaky
                36...40 // Annoyey
            ]
        }
        
        // color to int
        func toInt() -> Int {
            return Int(self.rawValue)!
        }
    }
}