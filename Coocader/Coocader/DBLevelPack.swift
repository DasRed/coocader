import Foundation
import CoreData

class DBLevelPack: Database {

    /// shared instance
    class var shared: DBLevelPack {
        struct Static {
            static let instance: DBLevelPack = DBLevelPack()
        }
        return Static.instance
    }

    /// Data Structure
    private struct DataStructure: DataStructureProtocol {
        var id: String
        var buyed: Bool
        var managedObject: NSManagedObject

        /// creates the data Structure by managed object
        static func createByManagedObject(data: NSManagedObject) -> DataStructureProtocol? {
            guard let id = data.valueForKey("id") as? String else {
                return nil
            }

            guard let buyed = data.valueForKey("buyed") as? Bool else {
                return nil
            }

            return DataStructure(id: id, buyed: buyed, managedObject: data)
        }
    }

    /// entity name
    override internal func entityName() -> String {
        return "LevelPack"
    }

    /// data structure type
    override internal func dataStructure() -> DataStructureProtocol.Type {
        return DataStructure.self
    }

    /// was a level pack buyed
    func wasLevelPackBuyed(id: String) -> Bool {
        guard let entry = self.entries[id] else {
            return false
        }

        guard let levelPack = entry as? DataStructure else {
            return false
        }

        return levelPack.buyed
    }

    /// marks a level pack as buyed
    func markLevelPackAsBuyed(levelPack: LevelPack) {
        var entry: DataStructure? = self.entries[levelPack.id ] as? DataStructure

        if (entry == nil) {
            entry = DataStructure(
                id: levelPack.id,
                buyed: true,
                managedObject: self.managedObject
            )

            self.entries[levelPack.id] = entry

            entry!.managedObject.setValue(levelPack.id, forKey: "id")
        }

        entry!.buyed = true
        entry!.managedObject.setValue(true, forKey: "buyed")

        do {
            try entry!.managedObject.managedObjectContext!.save()
        }
        catch let error as NSError  {
            NSLog("Could not save %@, %@", error, error.userInfo)
        }
    }
}
