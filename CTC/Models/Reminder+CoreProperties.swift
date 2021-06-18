import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var day: String?
    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16
   
}
