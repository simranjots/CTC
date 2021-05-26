//
//  User+CoreDataProperties.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-02-27.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var isloggedin: Bool
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var dob: String?
    @NSManaged public var practice: NSSet?

}

// MARK: Generated accessors for practice
extension User {

    @objc(addPracticeObject:)
    @NSManaged public func addToPractice(_ value: Practice)

    @objc(removePracticeObject:)
    @NSManaged public func removeFromPractice(_ value: Practice)

    @objc(addPractice:)
    @NSManaged public func addToPractice(_ values: NSSet)

    @objc(removePractice:)
    @NSManaged public func removeFromPractice(_ values: NSSet)

}
