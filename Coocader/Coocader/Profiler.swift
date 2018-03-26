import Foundation

class Profiler {
    static var times: [String: CFAbsoluteTime] = [:]
    
    static func start(key: String) {
        Profiler.times[key] = CFAbsoluteTimeGetCurrent()
    }
    
    static func stop(key: String) -> CFAbsoluteTime {
        let time = CFAbsoluteTimeGetCurrent() - Profiler.times[key]!
        
        NSLog("Profiler: %@: %.05f", key, time)
        Profiler.times.removeValueForKey(key)
        
        return time
    }
    
}