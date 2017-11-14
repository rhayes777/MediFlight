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
    
    /// The time zone of the origin country
    var originTimeZone: TimeZone {
        return TimeZone(identifier: self.from!)!
    }
    
    
    /// The time zone of the desination country
    var destinationTimeZone: TimeZone {
        return TimeZone(identifier: self.to!)!
    }
    
    /// The time difference, in seconds, between the destination and origin time zones. A positive difference indicates a time zone that is further ahead (i.e. east)
    var timeDifference: Int {
        return destinationTimeZone.secondsFromGMT(for: self.on! as Date) - originTimeZone.secondsFromGMT(for: self.on! as Date)
    }
    
    /// Determine what time of day it will be in the origin country at a given time of day in the destination country
    ///
    /// - Parameter timeOfDay: The time of day in hours and minutes at the destination country
    /// - Returns: The time of day in hours and minutes that it will be in the origin country
    func apparentNewTimeOfDay(timeOfDay: TimeOfDay) -> TimeOfDay {
        return timeOfDay.shiftedBy(timeDifference: -self.timeDifference)
    }
    
    /// Determine what time of day it will be in the destination country at a given time of day in the origin country
    ///
    /// - Parameter timeOfDay: The time of day in hours and minutes at the origin country
    /// - Returns: The time of day in hours and minutes that it will be in the destination country
    func apparentOldTimeOfDay(timeOfDay: TimeOfDay) -> TimeOfDay {
        return timeOfDay.shiftedBy(timeDifference: self.timeDifference)
    }
    
    /// Generate a schedule for when pills should be taken
    ///
    /// - Parameters:
    ///   - doses: A set of doses taken in the origin country
    ///   - fromDate: The date from which to start the new schedule
    /// - Returns: A set of doses and dates on which pills should be taken
    func schedule(doses: [Dose], fromDate: Date, context: NSManagedObjectContext) -> [(Date, [Dose])] {
        let timeInterval = (self.on! as Date).timeIntervalSince(fromDate)
        let days = Int(timeInterval / (3600 * 24))
        let destinationTimes = doses.map { self.apparentNewTimeOfDay(timeOfDay: $0.timeOfDay )}
        let shortestDifferences = zip(doses, destinationTimes).map { (dose, destinationTime) -> TimeOfDayDelta in
            return dose.timeOfDay.shortestDistanceTo(newTimeOfDay: destinationTime)
        }
        let steps = shortestDifferences.map { $0 / days }
        var tuples: [(Date, [Dose])] = []
        for day in 0..<days {
            let newDoses = zip(doses, steps).map({ (arg) -> Dose in
                
                let (dose, step) = arg
                return Dose(timeOfDay: dose.timeOfDay + day * step, pills: dose.pills as! Set<Pill>, context: context)
            })
            tuples.append((fromDate + TimeInterval(3600 * 24 * day), newDoses))
        }
        return tuples
    }

}
