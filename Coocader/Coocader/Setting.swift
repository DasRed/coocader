//
//  Settings.swift
//  Coocader
//
//  Created by Marco Starker on 04.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

class Setting: EventManagerProtocol {
    static let FONT_NAME = "Crystal Radio Kit"
    static let FONT_SIZE_NORMAL = CGFloat(50.0)
    static let FONT_SIZE_SMALL = CGFloat(22.0)
    static let FONT_STROKE_COLOR = UIColor(red: 0x91 / 0xFF, green: 0x15 / 0xFF, blue: 0x01 / 0xFF, alpha: 1.0)

    /// all events
    enum EventType: String, EventTypeProtocol {
        case MusicEnabledHasChanged = "setting.musicEnabledHasChanged"
        case SoundEnabledHasChanged = "setting.soundEnabledHasChanged"
        case AdEnabledHasChanged = "setting.adEnabledHasChanged"
        case LastSelectedLevelPackHasChanged = "setting.lastSelectedLevelPackHasChanged"
        case LastSelectedLevelsHasChanged = "setting.lastSelectedLevelsHasChanged"
        case TimeLimitOfEndlessModeEnabledHasChanged = "setting.timeLimitOfEndlessModeEnabledHasChanged"
    }
    
    /// the settings
    private let settings: NSUserDefaults = NSUserDefaults.standardUserDefaults()
  
    /// setting for music enabled or not
    var musicEnabled: Bool {
        get {
            if (self.settings.objectForKey("setting.music.enabled") == nil) {
                return true
            }
            
            return self.settings.boolForKey("setting.music.enabled")
        }
        set(state) {
            let previousState = self.musicEnabled
            if (state == previousState) {
                return
            }
            
            self.settings.setBool(state, forKey: "setting.music.enabled")
            
            // trigger the change event
            self.trigger(Setting.EventType.MusicEnabledHasChanged)
        }
    }
    
    /// setting for sound enabled or not
    var soundEnabled: Bool {
        get {
            if (self.settings.objectForKey("setting.sound.enabled") == nil) {
                return true
            }
            
            return self.settings.boolForKey("setting.sound.enabled")
        }
        set(state) {
            let previousState = self.soundEnabled
            if (state == previousState) {
                return
            }

            self.settings.setBool(state, forKey: "setting.sound.enabled")
            
            // trigger the change event
            self.trigger(Setting.EventType.SoundEnabledHasChanged)
        }
    }
    
    /// setting for ad enabled or not
    var adEnabled: Bool {
        get {
            #if !AD_DISABLED
                if (self.settings.objectForKey("setting.ad.enabled") == nil) {
                    return true
                }
                
                return self.settings.boolForKey("setting.ad.enabled")
            #else
                return false
            #endif
        }
        set(state) {
            #if !AD_DISABLED
                let previousState = self.adEnabled
                if (state == previousState) {
                    return
                }
                
                self.settings.setBool(state, forKey: "setting.ad.enabled")
                
                // trigger the change event
                self.trigger(Setting.EventType.AdEnabledHasChanged)
            #endif
        }
    }

    /// setting for last selected level pack
    var lastSelectedLevelPack: LevelPack? {
        get {
            guard let id = self.settings.stringForKey("setting.levelPack.selected") else {
                return nil
            }

            guard let levelPack = LevelPackHandler.shared.levelPacks[id] else {
                return nil
            }

            return levelPack
        }
        set(levelPack) {
            if (levelPack == nil) {
                self.settings.setNilValueForKey("setting.levelPack.selected")
            }
            else {
                self.settings.setObject(levelPack!.id, forKey: "setting.levelPack.selected")
            }

            // trigger the change event
            self.trigger(Setting.EventType.LastSelectedLevelPackHasChanged)
        }
    }

    /// returns last selected levels mapped by levelpack id
    var lastSelectedLevels: [String: String] {
        get {
            guard let data = self.settings.valueForKey("setting.levels.selected") else {
                return [:]
            }

            guard let levels = data as? [String: String] else {
                return [:]
            }

            return levels
        }
        set(levels) {
            self.settings.setValue(levels, forKey: "setting.levels.selected")
            // trigger the change event
            self.trigger(Setting.EventType.LastSelectedLevelsHasChanged)
        }
    }

    /// setting for time limit in endless mode enabled
    var timeLimitOfEndlessModeEnabled: Bool {
        get {
            if (self.settings.objectForKey("setting.timeLimitOfEndlessModeEnabled.enabled") == nil) {
                return true
            }

            return self.settings.boolForKey("setting.timeLimitOfEndlessModeEnabled.enabled")
        }
        set(state) {
            let previousState = self.adEnabled
            if (state == previousState) {
                return
            }

            self.settings.setBool(state, forKey: "setting.timeLimitOfEndlessModeEnabled.enabled")

            // trigger the change event
            self.trigger(Setting.EventType.TimeLimitOfEndlessModeEnabledHasChanged)
        }
    }

    // shared instance
    static private var instance: Setting?
    
    // returns a global charted instance
    static func sharedSetting() -> Setting {
        if (Setting.instance == nil) {
            Setting.instance = Setting()
        }
        
        return Setting.instance!
    }
}