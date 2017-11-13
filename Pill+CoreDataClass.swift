//
//  Pill+CoreDataClass.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pill)
public class Pill: NSManagedObject {
    
    public init(name: String, dosage: Int16, context: NSManagedObjectContext?) {
        super.init(entity: (context?.persistentStoreCoordinator?.managedObjectModel.entitiesByName["Pill"]!)!, insertInto: context)
        
        self.name = name
        self.dosage = dosage
    }

}
