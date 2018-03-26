//
//  SpriteNode.swift
//  Coocader
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class SpriteNode: SKSpriteNode {
    
    /// automatic size by texture
    var automaticSizeByTexture: Bool = true
    
    /// texture atlas handler
    internal let textureAtlasHandler = TextureAtlasHandler.shared
    
    /// texture update
    override var texture: SKTexture? {
        didSet {
            if (self.automaticSizeByTexture == true && self.texture != nil) {
                self.size = self.texture!.size()
            }
        }
    }
    
    // init
    init(parent: SKNode? = nil, texture: String? = nil, atlas: TextureAtlasHandler.Names = .Game) {
        super.init(texture: nil, color: UIColor(), size: CGSize())
        
        if (texture != nil) {
            self.texture = self.textureAtlas(texture!, atlas: atlas)
        }
        
        if (parent != nil) {
            parent!.addChild(self)
        }
    }
    
    /// init
    init(parent: SKNode, texture: SKTexture) {
        super.init(texture: texture, color: UIColor(), size: CGSize())
        parent.addChild(self)
    }
    
    /// the texture from the texture atlas
    func textureAtlas(texture: String, atlas: TextureAtlasHandler.Names = .Game) -> SKTexture {
        return self.textureAtlasHandler.get(atlas, texture: texture)
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}