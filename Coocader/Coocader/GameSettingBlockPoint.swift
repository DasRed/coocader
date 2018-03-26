//
//  GameSettingBlock.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation


extension GameSetting {
    class BlockPoint: GameSettingSetting {        
        // block point for destruction
        func forDestruction(block: Block) -> Int {
            var value = block.width.toInt() + 1
            
            if (block.isGunner == true) {
                value += 1
            }
            
            switch self.game.difficulty {
            case .ScaredyCat: return 1
            case .Simple: return value
            case .Normal: return value + 1
            case .Hard: return (value + 1) * 2
            case .Extrem: return (value + 1) * 3
            }
        }
    }
}
