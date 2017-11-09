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
    
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    public static func ==(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute
    }
    
    public var description: String {
        return "\(String(format: "%02d", self.hour)):\(String(format: "%02d", self.minute))"
    }

}
