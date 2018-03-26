//
//  File.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class TextureAtlasHandler {
    // names
    enum Names: String {
        case General = "general"
        case Game = "game"
        case Level = "level"
    }
    
    // all atlases
    private var atlases: [String: SKTextureAtlas]! = [:]
    
    // singleton lazy loading
    static let shared: TextureAtlasHandler! = { return TextureAtlasHandler() }()
    
    /// cached textures by name
    private var textureCached: [String: SKTexture]! = [:]
    
    // singleton
    private init() {}
    
    // get one
    func get(atlas: Names) -> SKTextureAtlas {
        return self.get(atlas.rawValue)
    }
    
    // gets one
    func get(atlas: String) -> SKTextureAtlas {
        if (TextureAtlasHandler.shared.atlases[atlas] == nil) {
            TextureAtlasHandler.shared.atlases[atlas] = SKTextureAtlas(named: atlas)
        }
        
        return TextureAtlasHandler.shared.atlases[atlas]!
    }
    
    /// returns a cached texture by name and texture name
    func get(atlas: Names, texture: String) -> SKTexture {
        return self.get(atlas.rawValue, texture: texture)
    }
    
    /// returns a cached texture by name and texture name
    func get(atlas: String, texture: String) -> SKTexture {
        return self.getByFileName(atlas, texture: texture + ".png")
    }
    
    /// texture must contains the file name extension
    private func getByFileName(atlas: String, texture: String) -> SKTexture {
        let key = atlas + "/" + texture
        
        if (self.textureCached[key] == nil) {
            self.textureCached[key] = self.get(atlas).textureNamed(texture)
        }
        
        return self.textureCached[key]!
    }
}