import Foundation

extension GameSetting {
    
    // value definition
    struct RandomSet {
        /// min value
        var values: [Any]
        
        // construct
        init(_ values: [Any]) {
            self.values = values
        }
        
        // calc value
        func calc() -> Any {
            let index = 0.random(self.values.count - 1)
            return self.values[index]
        }
    }
}