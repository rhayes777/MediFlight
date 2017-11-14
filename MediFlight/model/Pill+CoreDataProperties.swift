//
//  Pill+CoreDataProperties.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData


extension Pill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pill> {
        return NSFetchRequest<Pill>(entityName: "Pill")
    }

    @NSManaged public var name: String?
    @NSManaged public var dosage: Int16
    @NSManaged public var doses: NSSet?

}

// MARK: Generated accessors for doses
extension Pill {

    @objc(addDosesObject:)
    @NSManaged public func addToDoses(_ value: Dose)

    @objc(removeDosesObject:)
    @NSManaged public func removeFromDoses(_ value: Dose)

    @objc(addDoses:)
    @NSManaged public func addToDoses(_ values: NSSet)

    @objc(removeDoses:)
    @NSManaged public func removeFromDoses(_ values: NSSet)

}
