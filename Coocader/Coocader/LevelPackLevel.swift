//
//  Level.swift
//  Coocader
//
//  Created by Marco Starker on 16.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension LevelPack {
    internal class Level {

        /// the id of this level
        private(set) var id: String = ""

        /// all localized names
        private(set) var name: String = ""

        /// defines the difficulty
        private(set) var difficulty: GameSetting.Difficulty = .Normal

        /// contains all required other levels of this levelpack wich must be completed
        private(set) var require: [String] = []

        /// is this level completed
        var completed: Bool {
            get {
                return DBLevel.shared.isLevelCompleted(self)
            }
            set {
                DBLevel.shared.markLevelCompleted(self)
            }
        }

        /// test if level is playable
        var playable: Bool {
            get {
                // requirements must be solved
                if (self.require.count != 0) {
                    for id in self.require {
                        guard let level = self.levelPack.levels[id] else {
                            continue
                        }

                        if (level.completed == false) {
                            return false
                        }
                    }
                }
                
                // success
                return true
            }
        }

        /// contains all block definition for the matrix
        lazy private(set) var matrix: Matrix! = {
            var matrix: Matrix = Matrix()

            for block in self.matrixData {
                matrix.append(BlockDefinition(level: self, json: block))
            }

            return matrix
        }()

        /// cached matrix data
        private var matrixData: [[String: AnyObject]] = []

        /// the levelpack which contains this level
        private(set) var levelPack: LevelPack!

        /// current index in levelpack
        private(set) var index: Int!

        /// the game setting for this level
        internal var gameSetting: GameSetting!

        /// nächstes spielbare level
        var nextPlayable: Level? {
            get {
                let levels = self.levelPack.sorted()
                guard var index = levels.indexOf({ $0 === self }) else {
                    return nil
                }

                /// search next in list
                for index++; index < levels.count; index++ {
                    if (levels[index].playable == true) {
                        return levels[index]
                    }
                }

                // search next not completed in list
                for level in levels {
                    if (level.completed == false && level.playable == true) {
                        return level
                    }
                }


                return nil
            }
        }

        /// constructor
        init?(levelPack: LevelPack, index: Int, json: [String: AnyObject], levelPreviousId: String? = nil) {
            self.levelPack = levelPack
            self.index = index

            // test id
            self.id = String(index + 1)
            if ((json["id"] as? String) != nil) {
                self.id = json["id"] as! String
            }

            // test name
            self.name = "Level".localized + " " + self.id
            let name = levelPack.selectTextFromLanguageMapFromJson(json, key: "name")
            if (name != nil) {
                self.name = name!
            }

            // set the difficulty
            guard (json["difficulty"] as? Int) != nil else {
                NSLog("Level: Json does not contain valid difficulty")
                return nil
            }
            guard let difficulty = GameSetting.Difficulty(rawValue: String(json["difficulty"] as! Int)) else {
                NSLog("Level: Json does not contain valid difficulty value")
                return nil
            }
            self.difficulty = difficulty
            self.gameSetting = GameSetting(difficulty: self.difficulty)

            // test require
            if (json["require"] != nil) {
                /// it is a list of ids
                if ((json["require"] as? [String]) != nil) {
                    self.require = json["require"] as! [String]
                }
                /// is is an string
                else if ((json["require"] as? String) != nil) {
                    /// take previous level
                    if ((json["require"] as! String).lowercaseString == "p") {
                        if (levelPreviousId != nil) {
                            self.require = [levelPreviousId!]
                        }
                    }
                    /// take as level id
                    else {
                        self.require = [json["require"] as! String]
                    }
                }
            }

            /// test matrix
            guard (json["matrix"] as? [[String: AnyObject]]) != nil else {
                NSLog("Level: Json does not contain valid matrix")
                return nil
            }

            /// store the raw data and create it later via lazy load 
            self.matrixData = json["matrix"] as! [[String: AnyObject]]
        }
    }
}