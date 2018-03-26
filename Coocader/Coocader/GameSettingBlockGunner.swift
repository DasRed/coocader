//
//  GameSettingBlockGunner.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    class BlockGunner: GameSettingSetting {
        
        // weight
        lazy var chanceThatIsGunner: Float = {
            switch self.game.difficulty {
            case .ScaredyCat: return 0.0
            case .Simple: return 0.0
            case .Normal: return 0.0
            case .Hard: return 0.5
            case .Extrem: return 1.0
            }
        }()
        
        // delta of moving down
        lazy var shotMovingDeltaY: Value = {
            switch self.game.difficulty {
            case .ScaredyCat: return Value(-60)
            case .Simple: return Value(-50)
            case .Normal: return Value(-40)
            case .Hard: return Value(-30)
            case .Extrem: return Value(-20)
            }
        }()
        
        // interval of shots
        lazy var shotInterval: [String: Int] = {
            switch self.game.difficulty {
            case .ScaredyCat: return ["min": 1000, "max": 1001]
            case .Simple: return ["min": 1000, "max": 1001]
            case .Normal: return ["min": 1000, "max": 1001]
            case .Hard: return ["min": 30, "max": 120]
            case .Extrem: return ["min": 10, "max": 60]
            }
        }()
        
        // duration of moving of delta of moving down
        lazy var shotMovingDeltaDuration: Value = {
            return self.game.shot.movingDeltaDuration
        }()
        
        // calc the chance
        func calcThatIsGunner() -> Bool {
            return Float(1.random(1001)) / 10.0 <= self.chanceThatIsGunner
        }
        
        // returns the shot interval
        func calcShotInterval() -> Float {
            let range = self.shotInterval
            
            return Float(range["min"]!.random(range["max"]! + 1)) / 10.0
        }
    }
}