//
//  WeeklyData+CoreDataProperties.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-08.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//
//

import Foundation
import CoreData


extension WeeklyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklyData> {
        return NSFetchRequest<WeeklyData>(entityName: "WeeklyData")
    }

    @NSManaged public var practice_name: String?
    @NSManaged public var no_of_days_practiced: Int32
    @NSManaged public var total_no_of_days: Int32
    @NSManaged public var start_date: NSDate?
    @NSManaged public var end_date: NSDate?

}
