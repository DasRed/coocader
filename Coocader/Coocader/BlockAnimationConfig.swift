import Foundation
import SpriteKit

extension Block {
    class AnimationConfig {
        
        // singleton
        static var instance: AnimationConfig?
        
        // texture atlas collection
        private var textures: [String: [SKTexture]]! = [:]
        
        // defines all animation frames
        private var animations: [Block.Face: Animation]! = {
            var data: [Block.Face: Animation]! = [:]
            
            data[.Masky] = Animation(0.05).frame(10, 1.5).frames(20, 100).frame(110, 1.5).frames(120, 200)
            data[.Evil] = Animation(0.05).frames(10, 400)
            data[.Sleepy] = Animation(0.15).frame(10, 1.5).frames(20, 30).frame(40, 0.5).frames(50, 60)
            data[.Hiddy] = Animation(0.15).frame(10, 1.5).frames(20, 40).frame(50, 1.5).frames(60, 80)
            data[.Dummy] = Animation(0.075).frame(10, 1.5).frames(20, 260)
            data[.Frighty] = Animation(0.15).frame(10, 1.5).frames(20, 60)
            data[.Sneaky] = Animation(1.5).frames(10, 30)
            data[.Annoyey] = Animation(0.15).frame(10, 1.5).frames(20, 200)
            
            return data
        }()
        
        // animate with textures cache
        private var animateWithTexturesCache: [String: SKAction] = [:]

        // singleton
        private init() {}
        
        // singleton
        static func sharedAnimationConfig() -> AnimationConfig {
            if (AnimationConfig.instance == nil) {
                AnimationConfig.instance = AnimationConfig()
            }
            
            return AnimationConfig.instance!
        }
        
        /// returns the animation config
        func animation(face: Face) -> Animation {
            return self.animations[face]!
        }
        
        // returns the animation config
        func animation(block: Block) -> Animation {
            return self.animation(block.face)
        }
        
        // textures for the animation by the block
        func textures(block: Block) -> [SKTexture] {
            let key = block.face.rawValue + "/" + block.width.rawValue + "/" + block.color.rawValue
            
            if (self.textures[key] == nil) {
                self.textures[key] = self.animation(block).frameMap().map({(frame: Animation.Frame) in
                    return block.texture(frame)
                })
            }
            
            return self.textures[key]!
        }
        
        /// returns the complete cached SKAction
        func animateWithTextures(block: Block) -> SKAction {
            let key = block.face.rawValue + "/" + block.width.rawValue + "/" + block.color.rawValue
            
            if (self.animateWithTexturesCache[key] == nil) {
                self.animateWithTexturesCache[key] = SKAction.animateWithTextures(
                    self.textures(block),
                    timePerFrame: NSTimeInterval(self.animation(block).getDurationPerFrameMin())
                )
            }

            return SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.waitForDuration(NSTimeInterval(Float(0.random(300)) / 10.0)),
                    self.animateWithTexturesCache[key]!
                ])
            )
        }
    }
    
    // returns the full animation
    func animationForAction() -> SKAction {
        return AnimationConfig.sharedAnimationConfig().animateWithTextures(self)
    }
}