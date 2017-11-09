//
//  Dose+CoreDataClass.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dose)
public class Dose: NSManagedObject {
    
    public init(timeOfDay: TimeOfDay, pills: Set<Pill>, context: NSManagedObjectContext?) {
        super.init(entity: (context?.persistentStoreCoordinator?.managedObjectModel.entitiesByName["Dose"]!)!, insertInto: context)
        
        self.timeOfDay = timeOfDay
        self.pills = pills as NSSet
    }

}
