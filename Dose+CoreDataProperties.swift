//
//  Dose+CoreDataProperties.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData


extension Dose {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dose> {
        return NSFetchRequest<Dose>(entityName: "Dose")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16
    @NSManaged public var pills: NSSet?

}

// MARK: Generated accessors for pills
extension Dose {

    @objc(addPillsObject:)
    @NSManaged public func addToPills(_ value: Pill)

    @objc(removePillsObject:)
    @NSManaged public func removeFromPills(_ value: Pill)

    @objc(addPills:)
    @NSManaged public func addToPills(_ values: NSSet)

    @objc(removePills:)
    @NSManaged public func removeFromPills(_ values: NSSet)

}
