import Foundation
import CoreData

protocol DataStructureProtocol {
    /// returns an identifier
    var id: String { get }

    /// returns the managed object
    var managedObject: NSManagedObject { get }

    /// creates the data Structure by managed object
    static func createByManagedObject(data: NSManagedObject) -> DataStructureProtocol?
}