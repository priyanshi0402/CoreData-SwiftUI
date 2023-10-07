//
//  College+CoreDataProperties.swift
//  CoreData-SwiftUI
//
//  Created by Priyanshi Bhikadiya on 01/10/23.
//
//

import Foundation
import CoreData


extension College {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<College> {
        return NSFetchRequest<College>(entityName: "College")
    }

    @NSManaged public var city: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var university: String?
    @NSManaged public var collegeToStudent: NSSet?
    
    public var students: [Student] {
        let set = collegeToStudent as? Set<Student> ?? []
        return set.sorted { $0.id > $1.id
        }
    }

}

// MARK: Generated accessors for collegeToStudent
extension College {

    @objc(addCollegeToStudentObject:)
    @NSManaged public func addToCollegeToStudent(_ value: Student)

    @objc(removeCollegeToStudentObject:)
    @NSManaged public func removeFromCollegeToStudent(_ value: Student)

    @objc(addCollegeToStudent:)
    @NSManaged public func addToCollegeToStudent(_ values: NSSet)

    @objc(removeCollegeToStudent:)
    @NSManaged public func removeFromCollegeToStudent(_ values: NSSet)

}

extension College : Identifiable {

}
