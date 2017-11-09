//
//  TimeOfDay+CoreDataClass.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//
//

import Foundation

public class TimeOfDay: Equatable, CustomStringConvertible {
    
    let hour: Int
    let minute: Int
    
    public init(hour: Int, minute: Int=0) {
        self.hour = hour
        self.minute = minute
    }
    
    public static func ==(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute
    }
    
    public var description: String {
        return "\(String(format: "%02d", self.hour)):\(String(format: "%02d", self.minute))"
    }
    
    public func shiftedBy(hours: Int=0, minutes: Int=0)->TimeOfDay {
        var newHour = self.hour + hours
        var newMinute = self.minute + minutes
        if newMinute < 0 {
            newMinute = 60 + newMinute
            newHour -= 1
        }
        if newMinute >= 60 {
            newMinute -= 60
            newHour += 1
        }
        if newHour < 0 {
            newHour = 24 + newHour
        }
        if newHour >= 24 {
            newHour -= 24
        }
        return TimeOfDay(hour: newHour, minute: newMinute)
    }

}
