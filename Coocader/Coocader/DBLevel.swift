import Foundation
import CoreData

class DBLevel: Database {

    /// shared instance
    class var shared: DBLevel {
        struct Static {
            static let instance: DBLevel = DBLevel()
        }
        return Static.instance
    }

    /// Data Structure
    private struct DataStructure: DataStructureProtocol {
        var id: String {
            get {
                return self.levelPackId + "." + self.levelId
            }
        }
        var levelPackId: String
        var levelId: String
        var completed: Bool
        var dateCompleted: NSDate
        var managedObject: NSManagedObject

        /// creates the data Structure by managed object
        static func createByManagedObject(data: NSManagedObject) -> DataStructureProtocol? {
            guard let levelPackId = data.valueForKey("levelPackId") as? String else {
                return nil
            }
            guard let levelId = data.valueForKey("levelId") as? String else {
                return nil
            }
            guard let completed = data.valueForKey("completed") as? Bool else {
                return nil
            }
            guard let dateCompleted = data.valueForKey("dateCompleted") as? NSDate else {
                return nil
            }

            return DataStructure(levelPackId: levelPackId, levelId: levelId, completed: completed, dateCompleted: dateCompleted, managedObject: data)
        }
    }

    /// entity name
    override internal func entityName() -> String {
        return "Level"
    }

    /// data structure type
    override internal func dataStructure() -> DataStructureProtocol.Type {
        return DataStructure.self
    }

    /// is a level completed
    func isLevelCompleted(level: LevelPack.Level) -> Bool {
        guard let entry = self.entries[level.levelPack.id + "." + level.id] else {
            return false
        }

        guard let level = entry as? DataStructure else {
            return false
        }

        return level.completed
    }

    /// marks a level as completed
    func markLevelCompleted(level: LevelPack.Level) {
        var entry: DataStructure? = self.entries[level.levelPack.id + "." + level.id] as? DataStructure

        if (entry == nil) {
            entry = DataStructure(
                levelPackId: level.levelPack.id,
                levelId: level.id,
                completed: true,
                dateCompleted: NSDate(),
                managedObject: self.managedObject
            )

            self.entries[level.levelPack.id + "." + level.id] = entry

            entry!.managedObject.setValue(level.levelPack.id, forKey: "levelPackId")
            entry!.managedObject.setValue(level.id, forKey: "levelId")
            entry!.managedObject.setValue(entry!.dateCompleted, forKey: "dateCompleted")
        }

        entry!.completed = true
        entry!.managedObject.setValue(true, forKey: "completed")

        do {
            try entry!.managedObject.managedObjectContext!.save()
        }
        catch let error as NSError  {
            NSLog("Could not save %@, %@", error, error.userInfo)
        }
    }
}
