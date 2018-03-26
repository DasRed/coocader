import Foundation

extension GameSetting {
    class BlockGiver: GameSettingSetting {
        
        // weight
        lazy var chanceThatIsGiver: Float = {
            switch self.game.difficulty {
            case .ScaredyCat: return 5.0
            case .Simple: return 4.0
            case .Normal: return 3.0
            case .Hard: return 2.0
            case .Extrem: return 2.0
            }
        }()
        
        // weight increasement for type: isGunner
        lazy var weightIncreasmentForGunner: Float = {
            switch self.game.difficulty {
            case .ScaredyCat: return 2.0
            case .Simple: return 2.0
            case .Normal: return 2.0
            case .Hard: return 2.0
            case .Extrem: return 2.0
            }
        }()

        // weight increasement for type: isColorSwitcher
        lazy var weightIncreasmentForColorSwitcher: Float = {
            switch self.game.difficulty {
            case .ScaredyCat: return 2.0
            case .Simple: return 2.0
            case .Normal: return 2.0
            case .Hard: return 2.0
            case .Extrem: return 2.0
            }
        }()
        
        // calc the chance
        func calcThatIsGiver(block: Block) -> Bool {
            var weight = self.chanceThatIsGiver
            
            if (block.isGunner == true) {
                weight += self.weightIncreasmentForGunner
            }
            
            if (block.countOfColorSwitch > 0) {
                weight += self.weightIncreasmentForColorSwitcher
            }
            
            return Float(1.random(1001)) / 10.0 <= weight
        }
    }
}