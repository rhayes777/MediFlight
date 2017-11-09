//
//  Flight+CoreDataClass.swift
//  PillZones
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Flight)
public class Flight: NSManagedObject {
    
    public init(from: String, to: String, on: NSDate, context: NSManagedObjectContext?) {
        super.init(entity: (context?.persistentStoreCoordinator?.managedObjectModel.entitiesByName["Flight"]!)!, insertInto: context)
        
        self.from = from
        self.to = to
        self.on = on
    }
    
    var originTimeZone: TimeZone {
        return TimeZone(identifier: self.from!)!
    }
    
    var destinationTimeZone: TimeZone {
        return TimeZone(identifier: self.to!)!
    }
    
    var timeDifference: Int {
        return destinationTimeZone.secondsFromGMT(for: self.on! as Date) - originTimeZone.secondsFromGMT(for: self.on! as Date)
    }

}
