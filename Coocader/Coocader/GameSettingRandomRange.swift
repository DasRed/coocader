import Foundation

extension GameSetting {
    
    // value definition
    struct RandomRange {
        /// min value
        var min: Float!
        
        /// max value
        var max: Float!
        
        // factor
        var factor: Int!
        
        // construct
        init(_ min: Float, _ max: Float, factor: Int = 10) {
            self.min = min
            self.max = max
            self.factor = factor
        }
        
        // calc value
        func calc() -> Float {
            let min = self.min * Float(self.factor)
            let max = self.max * Float(self.factor)
            
            return Float(Int(min).random(Int(max) + 1)) / Float(self.factor)
        }
    }
}