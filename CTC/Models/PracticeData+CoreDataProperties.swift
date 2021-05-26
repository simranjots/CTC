//
//  PracticeData+CoreDataProperties.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-02-22.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//
//

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

}
