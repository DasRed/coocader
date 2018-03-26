//
//  DebugNode.swift
//  Coocader
//
//  Created by Marco Starker on 05.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

#if DEBUG
    class DebugNode: SKNode {
        enum EventType: String, EventTypeProtocol {
            case ToggleGiftNodes = "ToggleGiftNodes"
        }
        
        var options: [String: () -> Void] = [
            "Settings to default": {
                let setting = Setting.sharedSetting()
                setting.musicEnabled = true
                setting.soundEnabled = true
                setting.adEnabled = true
            },
            "Enable Ad": { Setting.sharedSetting().adEnabled = true },
            "Alert": { SCLAlertView().showInfo("Test Title", subTitle: "This is a very important message!") },
            "Game: Give Reward: Warten": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.IncreaseBlockContainerMovingWaitingDuration) },
            "Game: Give Reward: Langsamer": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.IncreaseBlockContainerMovingDeltaDuration) },
            "Game: Give Reward: Angst": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.IncreaseBlockContainerPositionY) },

            "Game: Give Reward: Eilig": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.DecreaseBlockContainerMovingWaitingDuration) },
            "Game: Give Reward: Schneller": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.DecreaseBlockContainerMovingDeltaDuration) },
            "Game: Give Reward: Mut": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.DecreaseBlockContainerPositionY) },

            "Game: Give Reward: Destroy First Line": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.DestroyFirstLineInMatrix) },
            "Game: Give Reward: Bomb the User": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.BombTheUser) },
            "Game: Give Reward: Deathline kills block": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.DeathLineKillsBlocks) },
            "Game: Give Reward: Ship shots spectral": { EventManager.sharedEventManager().trigger(GiftNode.EventType.RewardToGive, Block.Reward.ShipShotsSpectral) },
            "Game: Reward: Toggle Giver Block": { EventManager.sharedEventManager().trigger(DebugNode.EventType.ToggleGiftNodes) },

            "LevelMode: Unset all Completed Levels": { DBLevel.shared.deleteAll() },
            "LevelMode: Unset all Buyed LevelPackss": { DBLevelPack.shared.deleteAll() },

            "Generate LevelPacks" : {DebugNode.generateLevelPacks()},

            "Enable Time Limit Endless Game": { Setting.sharedSetting().timeLimitOfEndlessModeEnabled = true }
        ]

        var open: Bool! = false
        
        var menu: [MenuLabel]! = []
        
        var backgroundBig: SKShapeNode!
        
        var backgroundSmall: SKShapeNode!
        
        init(scene: BaseScene) {
            super.init()
            scene.addChild(self)
            self.setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        // init
        func setup() {
            let eventHandler = EventListener()
            eventHandler.callback = {(event: Event) in
                Setting.sharedSetting().removeListener(Setting.EventType.AdEnabledHasChanged, eventHandler)
                _ = DebugNode(scene: self.scene as! BaseScene)
                self.removeFromParent()
                return nil
            }
            Setting.sharedSetting().addListener(Setting.EventType.AdEnabledHasChanged, eventHandler)
            if (self.scene != nil && self.scene!.view != nil) {
                self.scene!.view!.showsFPS = true
                self.scene!.view!.showsNodeCount = true
            }
            
            self.position.x = 0
            self.position.y = 0
            self.zPosition = ZPosition.Debug.rawValue

            let backgroundSmall = SKShapeNode(rect: CGRect(
                x: self.scene!.size.width / 2 - 70,
                y: 0, //self.scene!.size.height - 60.0 - (Setting.sharedSetting().adEnabled ? CGFloat(AdHandler.BANNER_HEIGHT) : 0),
                width: 140,
                height: 60
            ))
            backgroundSmall.fillColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.5)
            backgroundSmall.lineWidth = 0
            backgroundSmall.zPosition = ZPosition.Debug.rawValue
            self.backgroundSmall = backgroundSmall
            self.addChild(backgroundSmall)
            
            let backgroundBig = SKShapeNode(rect: CGRect(
                x: 0,
                y: 0,
                width: self.scene!.size.width,
                height: self.scene!.size.height
            ))
            backgroundBig.fillColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
            backgroundBig.lineWidth = 0
            backgroundBig.hidden = true
            backgroundBig.zPosition = ZPosition.Debug.rawValue
            self.backgroundBig = backgroundBig
            self.addChild(backgroundBig)
            
            let labelDebug = MenuLabel(self, "Debug", 0.0, self.debugToggle)
            labelDebug.position = CGPoint(
                x: self.scene!.size.width / 2 - 60.0,
                y: 10 // self.scene!.size.height - 50 - CGFloat(Setting.sharedSetting().adEnabled ? CGFloat(AdHandler.BANNER_HEIGHT) : 0)
            )
            labelDebug.horizontalAlignmentMode = .Left
            labelDebug.verticalAlignmentMode = .Bottom
            labelDebug.hidden = false
            labelDebug.fontColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.75)
            labelDebug.zPosition = ZPosition.Debug.rawValue + 1

         
            for (text, option) in self.options {
                self.menu.append(MenuLabel(self, text, CGFloat(self.menu.count + 1), option))
            }
        }
        
        func debugToggle() {
            self.open = !self.open

            self.backgroundBig.hidden = !self.open
            self.backgroundSmall.hidden = self.open
            
            for menuLabel in self.menu {
                menuLabel.hidden = !self.open
            }
        }
        
        /* Menu Label */
        class MenuLabel: SKLabelNode {
            
            var onTouch: () -> Void = {}
            
            convenience init(_ parent: DebugNode, _ text: String, _ y: CGFloat, _ onTouch: () -> Void) {
                self.init(fontNamed: "Helvetica")
                
                self.fontName = "Helvetica"
                self.fontColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
                self.fontSize = text == "Debug" ? 40 : 20
                self.userInteractionEnabled = true
                self.hidden = true
                
                self.position = CGPoint(x: parent.scene!.size.width / 2, y: parent.scene!.size.height - 50 * (y + 1) - CGFloat(Setting.sharedSetting().adEnabled ? CGFloat(AdHandler.BANNER_HEIGHT) : 0))
                self.text = text
                self.zPosition = ZPosition.Debug.rawValue + 1

                self.onTouch = {
                    let duration:NSTimeInterval = 0.125
                    parent.backgroundBig.runAction(SKAction.customActionWithDuration(duration, actionBlock: {(node, elapsedTime) in
                        parent.backgroundBig.fillColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5 + 0.25 * elapsedTime / CGFloat(duration));
                    }))
                    
                    onTouch()
                }
                
                parent.addChild(self)
            }
            
            override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
                self.onTouch()
            }
        }



        static func generateLevelPacks() {

            for (count, name) in [15: "small", 40: "big"] {
                for difficulty in GameSetting.Difficulty.all() {
                    var levelpack: [String: AnyObject] = [:]
                    var levels: [[String: AnyObject]] = []
                    for var i = 0; i < count; i++ {
                        var level = [
                            "require": "p",
                            "difficulty": 0,
                            "matrix": []
                        ]

                        level["difficulty"] = difficulty.asInt()
                        var martrixX: [[String: AnyObject]] = []

                        GameSetting(difficulty: difficulty).declareAsDefault()
                        let matrix = Matrix()

                        // create all blocks
                        matrix.createAndAppendLines(countOfLines: EndlessPlayScene.INITIAL_LINES)

                        for blocks in matrix.blocks.values {
                            for block in blocks.values {
                                var blockX: [String: AnyObject] = [:]
                                blockX["x"] = block.position.matrixAccuracy.x
                                blockX["y"] = block.position.matrixAccuracy.y
                                blockX["color"] = block.color.toInt()
                                blockX["width"] = block.width.toInt()
                                blockX["face"] = block.face.toInt()

                                if (block.countOfColorSwitch != 0) {
                                    blockX["countOfColorSwitch"] = block.countOfColorSwitch
                                }

                                if (block.isGunner == true) {
                                    blockX["gunnerInterval"] = block.gunnerInterval
                                }

                                if (block.reward != nil) {
                                    blockX["reward"] = block.reward!.toInt()
                                }

                                martrixX.append(blockX)
                            }
                        }
                        level["matrix"] = martrixX

                        levels.append(level)
                    }
                    levelpack["levels"] = levels

                    let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
                    let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!

                    let jsonFilePath = documentsDirectoryPath.URLByAppendingPathComponent("levelpack-" + name + "-" + String(difficulty.asInt()) + ".clpf")
                    let fileManager = NSFileManager.defaultManager()
                    var isDirectory: ObjCBool = false
                    // creating a .json file in the Documents folder
                    if !fileManager.fileExistsAtPath(jsonFilePath.absoluteString, isDirectory: &isDirectory) {
                        let created = fileManager.createFileAtPath(jsonFilePath.absoluteString, contents: nil, attributes: nil)
                        if created {
                            print("File created " + jsonFilePath.absoluteString)
                        } else {
                            print("Couldn't create file for some reason" + jsonFilePath.absoluteString)
                        }
                    } else {
                        print("File already exists" + jsonFilePath.absoluteString)
                    }
                    
                    
                    let outputStream = NSOutputStream(toFileAtPath: jsonFilePath.absoluteString, append: false)
                    outputStream?.open()
                    NSJSONSerialization.writeJSONObject(
                        levelpack,
                        toStream: outputStream!,
                        options: NSJSONWritingOptions(),
                        error: nil)
                    outputStream?.close()
                }
            }

        }
    }
#endif