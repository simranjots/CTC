import Foundation
import CoreData


extension PracticeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PracticeData> {
        return NSFetchRequest<PracticeData>(entityName: "PracticeData")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var practised: Bool
    @NSManaged public var tracking_days: Int32
    @NSManaged public var practiceDataToPractice: Practice?
    @NSManaged public var streak: Int32

}
