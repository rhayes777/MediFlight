//
//  TimeOfDay+CoreDataClass.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation

public class TimeOfDayDelta: TimeOfDay {
    var absolute: TimeOfDayDelta {
        return TimeOfDayDelta(minutes: abs(self.minutes))
    }
    
    public static func /(lhs: TimeOfDayDelta, rhs: Int) -> TimeOfDayDelta {
        return TimeOfDayDelta(minutes: lhs.minutes / rhs)
    }
    
    public static func *(lhs: Int, rhs: TimeOfDayDelta) -> TimeOfDayDelta {
        return TimeOfDayDelta(minutes: lhs * rhs.minutes)
    }
}

public class TimeOfDay: Equatable, CustomStringConvertible {
    
    let minutes: Int
    public static let MINUTES_IN_A_DAY = 1440
    
    public init(hour: Int, minute: Int=0) {
        minutes = 60 * hour + minute
    }
    
    public init(minutes: Int) {
        self.minutes = minutes
    }
    
    public static func ==(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        return lhs.minutes == rhs.minutes
    }
    
    public static func -(lhs: TimeOfDay, rhs: TimeOfDay) -> TimeOfDayDelta {
        return TimeOfDayDelta(minutes: lhs.minutes - rhs.minutes)
    }
    
    public static func +(lhs: TimeOfDay, rhs: TimeOfDay) -> TimeOfDayDelta {
        return TimeOfDayDelta(minutes: lhs.minutes + rhs.minutes)
    }
    
    public static func <(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        return lhs.minutes < rhs.minutes
    }
    
    public static func >(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        return lhs.minutes > rhs.minutes
    }
    
    /// Returns a time delta representing the shortest difference in hours and minutes between two times of day. A negative hour and/or minute indicates that the difference is backwards in time
    ///
    /// - Parameter newTimeOfDay: The time of day to which the difference should be found. e.g. if this time of day is 12:00 and the newTimeOfDay is 13:30 then the result will be 1:30
    /// - Returns: A TimeOfDayDelta representing the difference between these two times
    public func shortestDistanceTo(newTimeOfDay: TimeOfDay) -> TimeOfDayDelta {
        let difference = newTimeOfDay - self
        if difference < TimeOfDayDelta(hour: -12) {
            return TimeOfDayDelta(hour: 24) + difference
        }
        if difference > TimeOfDayDelta(hour: 12) {
            return difference - TimeOfDayDelta(hour: 24)
        }
        return difference
    }
    
    public var hour: Int {
        return minutes / 60
    }
    
    public var minute: Int {
        return minutes % 60
    }
    
    public var description: String {
        return "\(String(format: "%02d", self.hour)):\(String(format: "%02d", self.minute))"
    }
    
    /// Creates a new TimeOfDay shifted by a given number of minutes
    ///
    /// - Parameter timeDifference: The difference in seconds
    /// - Returns: A NewTimeOfDay shifted my timeDifference seconds
    public func shiftedBy(timeDifference: Int)->TimeOfDay {
        var newMinutes = self.minutes + timeDifference / 60
        if newMinutes < 0 {
            newMinutes = TimeOfDay.MINUTES_IN_A_DAY + newMinutes
        }
        if newMinutes > TimeOfDay.MINUTES_IN_A_DAY {
            newMinutes = newMinutes - TimeOfDay.MINUTES_IN_A_DAY
        }
        return TimeOfDay(minutes: newMinutes)
    }

}
