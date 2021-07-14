//
//  Practice+CoreDataProperties.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-03-06.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//
//

import Foundation
import CoreData


extension Practice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Practice> {
        return NSFetchRequest<Practice>(entityName: "Practice")
    }

    @NSManaged public var image_name: String?
    @NSManaged public var practice: String?
    @NSManaged public var startedday: NSDate?
    @NSManaged public var is_deleted: Bool
    @NSManaged public var is_completed: Bool
    @NSManaged public var practiceData: NSSet?
    @NSManaged public var user: User?
    @NSManaged public var values: String?
    @NSManaged public var encourage: String?
    @NSManaged public var remindswitch: Bool
    @NSManaged public var goals: String?
    @NSManaged public var uId: String?

}

// MARK: Generated accessors for practiceData
extension Practice {

    @objc(addPracticeDataObject:)
    @NSManaged public func addToPracticeData(_ value: PracticeData)

    @objc(removePracticeDataObject:)
    @NSManaged public func removeFromPracticeData(_ value: PracticeData)

    @objc(addPracticeData:)
    @NSManaged public func addToPracticeData(_ values: NSSet)

    @objc(removePracticeData:)
    @NSManaged public func removeFromPracticeData(_ values: NSSet)

}
