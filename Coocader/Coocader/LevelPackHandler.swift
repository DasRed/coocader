import Foundation

class LevelPackHandler {

    /// defines the path for levels in the app
    static let PATH_IN_APP = "Levels"

    /// contains all level packs
    /// - to sort use: 
    /// -- .levelPacks.sort({ $0.0 < $1.0 }) for sorting by ID
    /// -- .levelPacks.sort({ $0.1.name < $1.1.name }) for sorting by Name
    /// -- .levelPacks.sort({ $0.1.dateCreation.compare($1.1.dateCreation) == .OrderedDescending }) for sorting by Date Creation
    internal(set) var levelPacks: [String: LevelPack] = [:]

    /// shared instance of LevelPackHandler
    class var shared: LevelPackHandler {
        struct Static {
            static let instance: LevelPackHandler = LevelPackHandler()
        }
        return Static.instance
    }

    /// constructor
    private init() {
        self.loadFromDisc()
    }

    /// load all data from disc out of the level directory
    private func loadFromDisc() {
        guard let path = NSBundle.mainBundle().pathForResource(LevelPackHandler.PATH_IN_APP, ofType: nil) else {
            return
        }

        guard let enumerator = NSFileManager.defaultManager().enumeratorAtPath(path) else {
            return
        }

        // load
        while let element = enumerator.nextObject() as? String {
            guard let levelPack = LevelPack(levelPackHandler: self, file: path + "/" + element) else {
                continue
            }

            self.levelPacks[levelPack.id] = levelPack
        }
    }

    /// returns sorted levelpack
    func sorted() -> [LevelPack] {
        return self.levelPacks.values.sort({ (levelPackA, levelPackB) -> Bool in
            return levelPackA.dateCreation.timeIntervalSince1970 < levelPackB.dateCreation.timeIntervalSince1970
        })
    }

    /// returns a level by level pack id and level id
    func get(levelPack levelPackId: String, level levelId: String) -> LevelPack.Level? {
        guard let levelPack = self.levelPacks[levelPackId] else {
            return nil
        }

        guard let level = levelPack.levels[levelId] else {
            return nil
        }

        return level
    }
}