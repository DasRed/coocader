//
//  GameCenter.swift
//  Coocader
//
//  Created by Marco Starker on 14.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

class GameCenter {
    
    // World Rankings
    enum WorldRank: String {
        case ScaredyCat = "worldRankScaredyCat"
        case Simple = "worldRankSimple"
        case Normal = "worldRankNormal"
        case Hard = "worldRankHard"
        case Extrem = "worldRankSuperhero"
    }

    /// init
    init(controller: GameViewController) {
        EGC.sharedInstance(controller)
        

        #if DEBUG
            // If you want see message debug
            EGC.debugMode = true
        #else
            EGC.debugMode = false
        #endif
    }
    
    /// stores points
    func store(points: Int, difficulty: GameSetting.Difficulty) {
        var list: WorldRank = .ScaredyCat
        
        switch difficulty {
        case .ScaredyCat:
            list = .ScaredyCat
            break
            
        case .Simple:
            list = .Simple
            break
            
        case .Normal:
            list = .Normal
            break
            
        case .Hard:
            list = .Hard
            break
            
        case .Extrem:
            list = .Extrem
            break
        }
        
        EGC.reportScoreLeaderboard(leaderboardIdentifier: list.rawValue, score: points)
    }
    
    // shows
    func showLeaderboard() {
        EGC.showGameCenterLeaderboard(leaderboardIdentifier: "xxx")
    }
}