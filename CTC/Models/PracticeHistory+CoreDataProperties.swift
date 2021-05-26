//
//  PracticeHistory+CoreDataProperties.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-03-14.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//
//

import Foundation
import CoreData


extension PracticeHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PracticeHistory> {
        return NSFetchRequest<PracticeHistory>(entityName: "PracticeHistory")
    }

    @NSManaged public var practice_name: String?
    @NSManaged public var td: Int32
    @NSManaged public var dss: Int32
    @NSManaged public var date: NSDate?
    @NSManaged public var com_del_flag: Bool

}
