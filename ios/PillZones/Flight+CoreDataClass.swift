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
    
    class func make(from: String, to: String, on: NSDate, context: NSManagedObjectContext)->Flight {
        let flight = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: context) as! Flight
        flight.from = from
        flight.to = to
        flight.on = on
        return flight
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
