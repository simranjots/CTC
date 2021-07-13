import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var uid: String?
    @NSManaged public var noteDate: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var practiceData: PracticeData?
 

}
