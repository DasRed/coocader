//
//  File.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    class LaserPointer: GameSettingSetting {
        
        // has laserPointer
        lazy var exists: Bool = {
            switch self.game.difficulty {
            case .ScaredyCat: return true
            case .Simple: return true
            case .Normal: return true
            case .Hard: return false
            case .Extrem: return false
            }
        }()
    }
}