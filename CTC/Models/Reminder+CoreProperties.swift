import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var day: String?
    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16
    @NSManaged public var practiceName: String?
    @NSManaged public var identifier: String?
    @NSManaged public var uid: String?
   
}
