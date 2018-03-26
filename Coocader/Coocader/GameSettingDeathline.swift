//
//  File.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

extension GameSetting {
    class Deathline: GameSettingSetting {
        // alpha
        lazy var alpha: CGFloat = {
            switch self.game.difficulty {
            case .ScaredyCat: return CGFloat(1.0)
            case .Simple: return CGFloat(0.75)
            case .Normal: return CGFloat(0.5)
            case .Hard: return CGFloat(0.25)
            case .Extrem: return CGFloat(0.05)
            }
        }()
    }
}