//
//  GameSettingReward.swift
//  Coocader
//
//  Created by Marco Starker on 13.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    class Reward: GameSettingSetting {
        
        // increaseBlockContainerMovingWaitingDuration reward
        lazy var increaseBlockContainerMovingWaitingDuration: RandomRange = {
            switch self.game.difficulty {
            case .ScaredyCat: return RandomRange(1.0, 2.0)
            case .Simple: return RandomRange(0.5, 1.5)
            case .Normal: return RandomRange(0.0, 1.0)
            case .Hard: return RandomRange(0.0, 0.5)
            case .Extrem: return RandomRange(0.0, 0.5)
            }
        }()

        // decreaseBlockContainerMovingWaitingDuration reward
        lazy var decreaseBlockContainerMovingWaitingDuration: RandomRange = { return self.increaseBlockContainerMovingWaitingDuration }()
        
        // increaseBlockContainerMovingDeltaDuration reward
        lazy var increaseBlockContainerMovingDeltaDuration: RandomRange = {
            switch self.game.difficulty {
            case .ScaredyCat: return RandomRange(0.0, 2.0)
            case .Simple: return RandomRange(0.0, 1.5)
            case .Normal: return RandomRange(0.0, 1.0)
            case .Hard: return RandomRange(0.0, 0.5)
            case .Extrem: return RandomRange(0.0, 0.25)
            }
        }()

        // decreaseBlockContainerMovingDeltaDuration reward
        lazy var decreaseBlockContainerMovingDeltaDuration: RandomRange = { return self.increaseBlockContainerMovingDeltaDuration }()
        
        // increaseBlockContainerPositionY reward
        lazy var increaseBlockContainerPositionY: RandomSet = {
            let height = Float(Block.Size.HEIGHT)
            
            switch self.game.difficulty {
            case .ScaredyCat: return RandomSet([1.0 * height, 2.0 * height, 3.0 * height, 4.0 * height])
            case .Simple: return RandomSet([1.0 * height, 2.0 * height, 3.0 * height])
            case .Normal: return RandomSet([1.0 * height, 2.0 * height])
            case .Hard: return RandomSet([0.0, 1.0 * height, 2.0 * height])
            case .Extrem: return RandomSet([0.0, 1.0 * height])
            }
        }()

        // decreaseBlockContainerPositionY reward
        lazy var decreaseBlockContainerPositionY: RandomSet = { self.increaseBlockContainerPositionY }()
        
        // DeathLineKillsBlocks reward
        lazy var deathLineKillsBlocksDuration: RandomRange = {
            switch self.game.difficulty {
            case .ScaredyCat: return RandomRange(30.0, 120.0)
            case .Simple: return RandomRange(20.0, 90.0)
            case .Normal: return RandomRange(10.0, 60.0)
            case .Hard: return RandomRange(10.0, 30.0)
            case .Extrem: return RandomRange(5.0, 15.0)
            }
        }()
        
        // ShipShotsSpectral reward
        lazy var shipShotsSpectral: RandomRange = {
            switch self.game.difficulty {
            case .ScaredyCat: return RandomRange(12.0, 30.0)
            case .Simple: return RandomRange(9.0, 25.0)
            case .Normal: return RandomRange(6.0, 20.0)
            case .Hard: return RandomRange(3.0, 15.0)
            case .Extrem: return RandomRange(1.0, 10.0)
            }
        }()
        
        // weight increasement for type: isGunner
        lazy var weightRewards: [Block.Reward: [String: Float]] = {
            switch self.game.difficulty {
            case .ScaredyCat: return [
                .IncreaseBlockContainerMovingWaitingDuration:   ["min": 0.0, "max": 14.2],
                .IncreaseBlockContainerMovingDeltaDuration:     ["min": 14.2, "max": 28.4],
                .IncreaseBlockContainerPositionY:               ["min": 28.4, "max": 42.6],
                .DestroyFirstLineInMatrix:                      ["min": 42.6, "max": 56.8],
                .DeathLineKillsBlocks:                          ["min": 56.8, "max": 71.0],
                .ShipShotsSpectral:                             ["min": 71.0, "max": 85.2],
                .DecreaseBlockContainerMovingWaitingDuration:   ["min": 85.2, "max": 90.0],
                .DecreaseBlockContainerMovingDeltaDuration:     ["min": 90.0, "max": 95.0],
                .DecreaseBlockContainerPositionY:               ["min": 95.0, "max": 100.0],
                ]
            case .Simple: return  [
                .BombTheUser:                                   ["min": 0.0, "max": 1.0],
                .IncreaseBlockContainerMovingWaitingDuration:   ["min": 1.0, "max": 12.0],
                .DecreaseBlockContainerMovingWaitingDuration:   ["min": 12.0, "max": 23.0],
                
                .IncreaseBlockContainerMovingDeltaDuration:     ["min": 23.0, "max": 34.0],
                .DecreaseBlockContainerMovingDeltaDuration:     ["min": 34.0, "max": 45.0],
                
                .IncreaseBlockContainerPositionY:               ["min": 45.0, "max": 56.0],
                .DecreaseBlockContainerPositionY:               ["min": 56.0, "max": 67.0],
                
                .DestroyFirstLineInMatrix:                      ["min": 67.0, "max": 78.0],
                .DeathLineKillsBlocks:                          ["min": 78.0, "max": 89.0],
                .ShipShotsSpectral:                             ["min": 89.0, "max": 100.0],
                ]
            case .Normal: return  [
                .BombTheUser:                                   ["min": 0.0, "max": 6.0],
                .ShipShotsSpectral:                             ["min": 6.0, "max": 12.0],

                .IncreaseBlockContainerMovingWaitingDuration:   ["min": 12.0, "max": 23.0],
                .DecreaseBlockContainerMovingWaitingDuration:   ["min": 23.0, "max": 34.0],
                
                .IncreaseBlockContainerMovingDeltaDuration:     ["min": 34.0, "max": 45.0],
                .DecreaseBlockContainerMovingDeltaDuration:     ["min": 45.0, "max": 56.0],
                
                .IncreaseBlockContainerPositionY:               ["min": 56.0, "max": 67.0],
                .DecreaseBlockContainerPositionY:               ["min": 67.0, "max": 78.0],
                
                .DestroyFirstLineInMatrix:                      ["min": 78.0, "max": 89.0],
                .DeathLineKillsBlocks:                          ["min": 89.0, "max": 100.0],
                ]
            case .Hard: return  [
                .BombTheUser:                                   ["min": 0.0, "max": 10.0],
                .IncreaseBlockContainerMovingWaitingDuration:   ["min": 10.0, "max": 28.0],
                .IncreaseBlockContainerMovingDeltaDuration:     ["min": 28.0, "max": 46.0],
                .IncreaseBlockContainerPositionY:               ["min": 46.0, "max": 64.0],
                .DecreaseBlockContainerPositionY:               ["min": 64.0, "max": 82.0],
                .DeathLineKillsBlocks:                          ["min": 82.0, "max": 100.0],
                ]
            case .Extrem: return  [
                .BombTheUser:                                   ["min": 0.0, "max": 20.0],
                .DeathLineKillsBlocks:                          ["min": 20.0, "max": 60.0],
                .IncreaseBlockContainerPositionY:               ["min": 60.0, "max": 100.0]
                ]
            }
        }()
        
        // calc the reward to give
        func calcReward() -> Block.Reward {
            var value = Float(0.random(1000)) / 10.0
            
            if (value > 100.0) {
                value = 100.0
            }
            
            for (reward, range) in self.weightRewards {
                if (range["min"] <= value && value < range["max"]) {
                    return reward
                }
            }
            
            return .DeathLineKillsBlocks
        }
    }
}