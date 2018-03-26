import Foundation

extension Block {

    /// all types of reward
    enum Reward: String {
        case IncreaseBlockContainerMovingWaitingDuration = "0"
        case DecreaseBlockContainerMovingWaitingDuration = "1"

        case IncreaseBlockContainerMovingDeltaDuration = "2"
        case DecreaseBlockContainerMovingDeltaDuration = "3"

        case IncreaseBlockContainerPositionY = "4"
        case DecreaseBlockContainerPositionY = "5"

        case DestroyFirstLineInMatrix = "6"
        case BombTheUser = "7"
        case DeathLineKillsBlocks = "8"
        case ShipShotsSpectral = "9"

        /// creates
        static func create(value: Int?) -> Reward? {
            guard value != nil else {
                return nil
            }

            guard let result = Reward(rawValue: String(value!)) else {
                return nil
            }

            return result
        }

        /// all
        static func all() -> [Reward] {
            return [
                .IncreaseBlockContainerMovingWaitingDuration,
                .DecreaseBlockContainerMovingWaitingDuration,
                .IncreaseBlockContainerMovingDeltaDuration,
                .DecreaseBlockContainerMovingDeltaDuration,
                .IncreaseBlockContainerPositionY,
                .DecreaseBlockContainerPositionY,
                .DestroyFirstLineInMatrix,
                .BombTheUser,
                .DeathLineKillsBlocks,
                .ShipShotsSpectral
            ]
        }

        // color to int
        func toInt() -> Int {
            return Int(self.rawValue)!
        }
    }
}