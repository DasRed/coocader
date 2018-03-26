//
//  LevelBlockNode.swift
//  Coocader
//
//  Created by Marco Starker on 19.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class LevelPackBlockNode: SKNode {
    
    /// init
    init(parent: SKNode, x: Int, y: Int, level: LevelPack.Level) {
        super.init()

        self.position = CGPoint(x: -150 + ((x % 6) * 60), y: 215 - (y * 70))
        self.zPosition = parent.zPosition + 1
        parent.addChild(self)

        // block node
        let blockNode = _BlockNode(parent: self, level: level)
        blockNode.zPosition = self.zPosition

        // handle level completed
        if (level.completed == true) {
            let completedNode = SpriteNode(parent: blockNode, texture: "status/completed-small", atlas: .Level)
            completedNode.zPosition = blockNode.zPosition + 1
        }

        // handle level playable
        if (level.playable == false) {
            let playableNode = SpriteNode(parent: blockNode, texture: "status/locked-small", atlas: .Level)
            playableNode.zPosition = blockNode.zPosition + 1
        }

        // shows difficulty
        _ = SmallStarsNode(parent: blockNode, difficulty: level.difficulty).position.y = -30
    }

    // init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// internal block simulation
    internal class _BlockNode: BlockNode {
        /// init
        init(parent: SKNode, level: LevelPack.Level) {
            // simulate the block
            var block: Block
            switch level.difficulty {
            case .ScaredyCat:
                block = Block(face: .Sleepy, width: .Once, color: .Pink)
                break

            case .Simple:
                block = Block(face: .Dummy, width: .Once, color: .Yellow)
                break

            case .Normal:
                block = Block(face: .Frighty, width: .Once, color: .Green)
                break

            case .Hard:
                block = Block(face: .Sneaky, width: .Once, color: .Red)
                break

            case .Extrem:
                block = Block(face: .Masky, width: .Once, color: .Purple)
                break

            }

            // init
            super.init(parent: parent, position: CGPoint(x: 0, y: 0), block: block, allowDelayedRender: false)
        }

        // init
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        /// setup events
        override internal func setupEvents() -> BlockNode {
            return self
        }
        
        /// setup attributes
        override internal func setupAttributes() -> BlockNode {
            return self
        }
        
        /// setup physics
        override internal func setupPhysics() -> BlockNode {
            return self
        }
        
        /// setup debug
        override internal func setupDebug() -> BlockNode {
            return self
        }
    }
}