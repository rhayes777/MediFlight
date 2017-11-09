//
//  PillZonesTests.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//

import XCTest
import CoreData

@testable import PillZones


class PillZonesTests: XCTestCase {
    
    var context = MockDatabaseManager().managedObjectContext()
    var date_1973 = Date(timeIntervalSince1970: 100000000)
    var flight: Flight?
    
    override func setUp() {
        super.setUp()
        context = MockDatabaseManager().managedObjectContext()
        date_1973 = Date(timeIntervalSince1970: 100000000)
        flight = Flight(from: "Europe/London", to: "Asia/Katmandu", on: date_1973 as NSDate, context: context)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeDifference() {
        date_1973 = Date(timeIntervalSince1970: 100000000)
        XCTAssertEqual(19800, flight!.timeDifference)
    }
    
    func testApparentNewTimeOfDay() {
        // 5 hours 30 minutes
        
        let there = flight!.apparentNewTimeOfDay(timeOfDay: TimeOfDay(hour:10, minute: 0))
        print(there)
        
        XCTAssertEqual(TimeOfDay(hour:4, minute: 30), there)
    }
    
}
