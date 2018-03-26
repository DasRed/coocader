
//
//  GameSetting.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    class BlockContainer: GameSettingSetting {
        static let INITIAL_POSITION_Y_NORMAL: Int = 1034

        // initial poition for y
        lazy var initialPositionY: Int = {
            switch self.game.difficulty {
            case .ScaredyCat: return BlockContainer.INITIAL_POSITION_Y_NORMAL - 200
            case .Simple: return BlockContainer.INITIAL_POSITION_Y_NORMAL - 200
            case .Normal: return BlockContainer.INITIAL_POSITION_Y_NORMAL
            case .Hard: return BlockContainer.INITIAL_POSITION_Y_NORMAL + 100
            case .Extrem: return BlockContainer.INITIAL_POSITION_Y_NORMAL + 100
            }
        }()
        
        // delta of moving down
        lazy var movingDeltaY: Value = {
            switch self.game.difficulty {
            case .ScaredyCat: return Value(-5)
            case .Simple: return Value(-10)
            case .Normal: return Value(-15)
            case .Hard: return Value(-20)
            case .Extrem: return Value(-30)
            }
        }()
        
        // duration of moving of delta of moving down
        lazy var movingDeltaDuration: Value = {
            switch self.game.difficulty {
            case .ScaredyCat: return Value(2, iterations: -2000)
            case .Simple: return Value(0.5, iterations: -1000)
            case .Normal: return Value(0.5, iterations: -500)
            case .Hard: return Value(0.4, iterations: -400)
            case .Extrem: return Value(0.3, iterations: -300)
            }
        }()
        
        // duration of waiting after moving down
        lazy var movingWaitingDuration: Value = {
            switch self.game.difficulty {
            case .ScaredyCat: return Value(3, iterations: -1000)
            case .Simple: return Value(2.5, iterations: -500)
            case .Normal: return Value(2, iterations: -250)
            case .Hard: return Value(1.5, iterations: -200)
            case .Extrem: return Value(1, iterations: -150)
            }
        }()
    }
}