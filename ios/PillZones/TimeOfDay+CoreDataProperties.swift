//
//  TimeOfDay+CoreDataProperties.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData


extension TimeOfDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeOfDay> {
        return NSFetchRequest<TimeOfDay>(entityName: "TimeOfDay")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16
    @NSManaged public var doses: Dose?

}
