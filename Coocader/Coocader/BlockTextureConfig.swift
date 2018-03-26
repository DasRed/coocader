//
//  BlockTextureConfig.swift
//  Coocader
//
//  Created by Marco Starker on 07.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

extension Block {
    class TextureConfig {
        
        // singleton
        static var instance: TextureConfig?
        
        /// texture atlas collection
        private var textureAtlases: [String: SKTextureAtlas]! = [:]
        
        /// all textures cached
        private var textureCache: [String: SKTexture] = [:]

        // singleton
        private init() {}
        
        // singleton
        static func sharedTextureConfig() -> TextureConfig {
            if (TextureConfig.instance == nil) {
                TextureConfig.instance = TextureConfig()
            }
            
            return TextureConfig.instance!
        }
        
        /// lazy loading of texture atlas
        private func textureAtlas(face: Face, width: Width) -> SKTextureAtlas {
            let key = "face-" + face.rawValue + "-" + width.rawValue
            
            if (self.textureAtlases[key] == nil) {
                self.textureAtlases[key] = SKTextureAtlas(named: "face-" + face.rawValue + "-" + width.rawValue)
            }
            
            return self.textureAtlases[key]!
        }
        
        // lazy loading of texture atlas
        private func textureAtlas(block: Block) -> SKTextureAtlas {
            return self.textureAtlas(block.face, width: block.width)
        }
        
        /// texture return by frame name
        func texture(face: Face, width: Width, color: Color, frame: String = "10") -> SKTexture {
            let key = "face-" + face.rawValue + "-" + width.rawValue + "/" + color.rawValue + "-" + frame + ".png"
            
            if (self.textureCache[key] == nil) {
                self.textureCache[key] = self.textureAtlas(face, width: width).textureNamed(color.rawValue + "-" + frame + ".png")
            }
            
            return self.textureCache[key]!
        }
        
        /// texture return by block and frame
        func texture(block: Block, frame: String = "10") -> SKTexture {
            return self.texture(block.face, width: block.width, color: block.color, frame: frame)
        }
        
        // texture return by animation frame
        func texture(block: Block, frame: Animation.Frame) -> SKTexture {
            return self.texture(block, frame: frame.name)
        }
        
        // preloads all blocks
        func preload() {
            for face in Face.all() {
                let animationConfig = AnimationConfig.sharedAnimationConfig().animation(face)
                for width in Width.all() {
                    for color in Color.all() {
                        for frame in animationConfig.frames {
                            self.texture(face, width: width, color: color, frame: frame.name)
                        }
                    }
                }
            }
        }
    }

    // returns the texture
    func texture(frame: String = "10") -> SKTexture {
        return TextureConfig.sharedTextureConfig().texture(self, frame: frame)
    }
    
    // returns the texture
    func texture(frame: Animation.Frame) -> SKTexture {
        return TextureConfig.sharedTextureConfig().texture(self, frame: frame)
    }
}