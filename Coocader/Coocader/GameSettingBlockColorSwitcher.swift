//
//  GameSettingBlockGunner.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    class BlockColorSwitcher: GameSettingSetting {
        
        // weight
        lazy var chanceThatIsColorSwitcher: Float = {
            switch self.game.difficulty {
            case .ScaredyCat: return 0.0
            case .Simple: return 1.0
            case .Normal: return 2.0
            case .Hard: return 5.0
            case .Extrem: return 10.0
            }
        }()
        
        // duration of moving of delta of moving down
        lazy var countOfColorSwitches: [String: Int] = {
            switch self.game.difficulty {
            case .ScaredyCat: return ["min": 0, "max": 0]
            case .Simple: return ["min": 1, "max": 1]
            case .Normal: return ["min": 1, "max": 1]
            case .Hard: return ["min": 1, "max": 2]
            case .Extrem: return ["min": 1, "max": 3]
            }
        }()
        
        // calc the chance
        func calcThatIsColorSwitcher() -> Bool {
            return Float(1.random(1001)) / 10.0 <= self.chanceThatIsColorSwitcher
        }
        
        // returns the shot interval
        func calcColorSwitchCount() -> Int {
            let range = self.countOfColorSwitches
            
            return range["min"]!.random(range["max"]! + 1)
        }
    }
}