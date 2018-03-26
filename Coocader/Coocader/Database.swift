import Foundation
import CoreData

class Database {
    /// the managed context
    internal var managedContext: NSManagedObjectContext {
        get {
            return AppDelegate.shared.managedObjectContext
        }
    }

    /// the managed object in DB
    internal var managedObject: NSManagedObject {
        get {
            let entity =  NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: self.managedContext)
            return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedContext)
        }
    }

    /// returns all data
    lazy internal var entries: [String: DataStructureProtocol] = {
        var entries: [String: DataStructureProtocol] = [:]

        let fetchRequest = NSFetchRequest(entityName: self.entityName())

        do {
            let result = (try self.managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]

            for data in result {
                guard let entry = self.dataStructure().createByManagedObject(data) else {
                    continue
                }
                entries[entry.id] = entry
            }

        }
        catch {
            return entries
        }

        return entries
    }()

    /// returns the entity name
    internal func entityName() -> String {
        fatalError("entityName must be overwriten")
    }

    /// data structure type
    internal func dataStructure() -> DataStructureProtocol.Type {
        fatalError("dataStructure must be overwriten")
    }

    /// deletes all entries
    func deleteAll() {
        for entry in self.entries.values {
            self.managedContext.deleteObject(entry.managedObject)
        }

        do {
            try self.managedContext.save()
            self.entries = [:]
        }
        catch let error as NSError  {
            NSLog("Could not save %@, %@", error, error.userInfo)
        }
    }
}