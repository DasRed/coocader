import Foundation
import SpriteKit

class Animation {
    
    // all frames in this animation
    var frames: [Frame]! = []
    
    // default duration for all frame
    var defaultDurationPerFrame: Float!
    
    /// minimum duration per frame
    var minDurationPerFrame: Float?
    
    // frame map
    private var frameMapCache: [Frame]?
    
    // construct
    init(_ defaultDurationPerFrame: Float) {
        self.defaultDurationPerFrame = defaultDurationPerFrame
    }
    
    // creates a frame
    func frame(name: Int, _ duration: Float? = nil) -> Animation {
        return self.frame(String(name), duration)
    }
    
    // creates a frame
    func frame(name: String, var _ duration: Float? = nil) -> Animation {
        duration = duration == nil ? self.defaultDurationPerFrame : duration
        
        if (self.minDurationPerFrame == nil || duration < self.minDurationPerFrame) {
            self.minDurationPerFrame = duration
        }
        
        self.frames.append(Frame(name: name, duration: duration))
        
        self.frameMapCache = nil
        
        return self
    }
    
    // multiple frames
    func frames(names: [Int], _ duration: Float? = nil) -> Animation {
        for name in names {
            self.frame(name, duration)
        }
        
        return self
    }
    
    // multiple frames
    func frames(names: [String], _ duration: Float? = nil) -> Animation {
        for name in names {
            self.frame(name, duration)
        }
        
        return self
    }
    
    // frames by range
    func frames(from: Int, _ to: Int, _ duration: Float? = nil, _ steps: Int = 10) -> Animation {
        for var i = from; i <= to; i += steps {
            self.frame(i, duration)
        }
        
        return self
    }
    
    // returns the absolute minimum of duration
    func getDurationPerFrameMin() -> Float {
        if (self.minDurationPerFrame == nil) {
            return 0.001
        }
        
        return self.minDurationPerFrame!
    }
    
    // creates the texture map
    func frameMap() -> [Frame] {
        if (self.frameMapCache == nil) {
            let durationMin = self.getDurationPerFrameMin()
            var frames: [Frame] = []
        
            for frame in self.frames {
                for var i: Int = 0; i < Int(ceil(frame.duration / durationMin)); i++ {
                    frames.append(frame)
                }
            }
            
            self.frameMapCache = frames
        }
        
        return self.frameMapCache!
    }
    
    // frame class
    internal class Frame {
        // name of the frame
        var name: String!
        
        // duration to show the animation frame
        var duration: Float!
        
        // construct
        init(name: String!, duration: Float!) {
            self.name = name
            self.duration = duration
        }
    }
}
