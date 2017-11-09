//
//  TimeOfDay+CoreDataClass.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TimeOfDay)
public class TimeOfDay: NSManagedObject {
    
    public init(hour: Int16, minute: Int16, context: NSManagedObjectContext?) {
        super.init(entity: (context?.persistentStoreCoordinator?.managedObjectModel.entitiesByName["TimeOfDay"]!)!, insertInto: context)
        
        self.hour = hour
        self.minute = minute
    }

}
