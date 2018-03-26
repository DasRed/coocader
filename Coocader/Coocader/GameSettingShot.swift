//
//  GameSettingShot.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    class Shot: GameSettingSetting {
        
        // delta of moving down
        lazy var movingDeltaY: Value = {
            switch self.game.difficulty {
            case .ScaredyCat: return Value(60)
            case .Simple: return Value(50)
            case .Normal: return Value(40)
            case .Hard: return Value(30)
            case .Extrem: return Value(20)
            }
        }()
        
        // duration of moving of delta of moving down
        lazy var movingDeltaDuration: Value = {
            switch self.game.difficulty {
            case .ScaredyCat: return Value(0.05)
            case .Simple: return Value(0.05)
            case .Normal: return Value(0.05)
            case .Hard: return Value(0.05)
            case .Extrem: return Value(0.05)
            }
        }()
        
        //fire waiting duration
        lazy var fireWaitingDuration: Float = {
            switch self.game.difficulty {
            case .ScaredyCat: return 0.2
            case .Simple: return 0.2
            case .Normal: return 0.2
            case .Hard: return 0.2
            case .Extrem: return 0.2
            }
        }()
    }
}