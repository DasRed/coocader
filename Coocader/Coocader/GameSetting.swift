//
//  GameSetting.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

class GameSetting {
    
    // difficulty Modes
    enum Difficulty: String {
        case ScaredyCat = "0"
        case Simple = "1"
        case Normal = "2"
        case Hard = "3"
        case Extrem = "4"
        
        // all
        static func all() -> [Difficulty] {
            return [.ScaredyCat, .Simple, .Normal, .Hard, .Extrem]
        }
        
        // all enabled values
        static func enabled() -> [Difficulty] {
            return [.ScaredyCat, .Simple, .Normal, .Hard, .Extrem]
        }

        /// returns the in expression for difficulty
        func asInt() -> Int {
            switch self {
            case .ScaredyCat: return 0
            case .Simple: return 1
            case .Normal: return 2
            case .Hard: return 3
            case .Extrem: return 4
            }
        }
    }

    // errors
    enum Error : ErrorType {
        case SharedIsNotInitialized
    }

    // current difficulty mode
    let difficulty: Difficulty
    
    // block container settings
    lazy private(set) var blockContainer: BlockContainer! = {
        return BlockContainer(game: self)
    }()
    
    // block point settings
    lazy private(set) var blockPoint: BlockPoint! = {
        return BlockPoint(game: self)
    }()
    
    // block gunner settings
    lazy private(set) var blockGunner: BlockGunner! = {
        return BlockGunner(game: self)
    }()
    
    // block color switch settings
    lazy private(set) var blockColorSwitcher: BlockColorSwitcher! = {
        return BlockColorSwitcher(game: self)
    }()
    
    // block giver settings
    lazy private(set) var blockGiver: BlockGiver! = {
        return BlockGiver(game: self)
    }()
    
    // gift settings
    lazy private(set) var gift: Gift! = {
        return Gift(game: self)
    }()
    
    // reward settings
    lazy private(set) var reward: Reward! = {
        return Reward(game: self)
    }()
    
    // shot settings
    lazy private(set) var shot: Shot! = {
        return Shot(game: self)
    }()
    
    // laserPointer settings
    lazy private(set) var laserPointer: LaserPointer! = {
        return LaserPointer(game: self)
    }()
    
    // deathline settings
    lazy private(set) var deathline: Deathline! = {
        return Deathline(game: self)
    }()
    
    // init
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
    }
    
    // decalares this as the default
    func declareAsDefault() -> GameSetting {
        GameSetting.shared = self
        
        return self
    }
    
    // the static
    private struct Static {
        static private var instance: GameSetting?
    }
  
    // shared
    static private(set) var shared: GameSetting {
        get {
            // not defined
            if (Static.instance == nil) {
                Static.instance = GameSetting(difficulty: .Normal)
            }
        
            return Static.instance!
        }
        
        set {
            Static.instance = newValue
        }
    }
}
