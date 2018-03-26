import Foundation
import SpriteKit

extension LevelPack {
    
    internal class BlockDefinition: Block {

        /// the level which contains this block
        let level: Level

        /// original json data
        let json: [String: AnyObject]

        /// game settings
        override internal var gameSetting: GameSetting {
            get {
                return self.level.gameSetting
            }
        }

        /// constructor with level and json data
        init(level: Level, json: [String: AnyObject]) {
            let x: Double? = json["x"] as? Double
            let y: Double? = json["y"] as? Double
            let color: Block.Color? = Block.Color.create(json["color"] as? Int)
            let width: Block.Width? = Block.Width.create(json["width"] as? Int)
            let face: Block.Face? = Block.Face.create(json["face"] as? Int)
            let gunnerInterval: Float? = json["gunnerInterval"] as? Float
            let isGunner: Bool = gunnerInterval != nil || gunnerInterval > 0
            let countOfColorSwitch: Int? = json["countOfColorSwitch"] as? Int
            let colorsForColorSwitch: [Int]? = json["colorsForColorSwitch"] as? [Int]
            let reward: Block.Reward? = Block.Reward.create(json["reward"] as? Int)

            self.level = level
            self.json = json

            if (x == nil) { NSLog("BlockDefinition: Json does not contains valid X") }
            if (y == nil) { NSLog("BlockDefinition: Json does not contains valid Y") }
            if (color == nil) { NSLog("BlockDefinition: Json does not contains valid Color") }
            if (width == nil) { NSLog("BlockDefinition: Json does not contains valid Width") }
            if (face == nil) { NSLog("BlockDefinition: Json does not contains valid Face") }

            // init
            super.init(
                face: face != nil ? face! : .Dummy,
                width: width != nil ? width! : .Once,
                color: color != nil ? color! : .Green,
                x: (x != nil ? x! : 0.0) + self.level.levelPack.xDelta,
                y: (y != nil ? y! : 0.0) + self.level.levelPack.yDelta,
                isGunner: isGunner,
                countOfColorSwitch: countOfColorSwitch != nil ? countOfColorSwitch! : 0,
                reward: reward
            )
            
            // gunner interval
            if (gunnerInterval != nil) {
                self.gunnerInterval = gunnerInterval!
            }

            // colors for color switch
            if (colorsForColorSwitch != nil) {
                for colorValue in colorsForColorSwitch! {
                    let color = Block.Color.create(colorValue)
                    if (color == nil) {
                        NSLog("BlockDefinition: Json does not contains valid Color for colorsForColorSwitch")
                        continue
                    }
                    self.colorsForColorSwitch.append(color!)
                }
            }
        }

        /// creates a copy of this object
        override func copy() -> BlockDefinition {
            return BlockDefinition(level: self.level, json: self.json)
        }
    }
}