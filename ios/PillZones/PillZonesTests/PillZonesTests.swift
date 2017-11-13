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
    var pill: Pill?
    var flight: Flight?
    
    override func setUp() {
        super.setUp()
        context = MockDatabaseManager().managedObjectContext()
        date_1973 = Date(timeIntervalSince1970: 100000000)
        flight = Flight(from: "Europe/London", to: "Asia/Katmandu", on: date_1973 as NSDate, context: context)
        pill = Pill(name: "Kepra", dosage: 500, context: context)
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
        XCTAssertEqual(TimeOfDay(hour:4, minute: 30), flight!.apparentNewTimeOfDay(timeOfDay: TimeOfDay(hour:10, minute: 0)))
        XCTAssertEqual(TimeOfDay(hour:22, minute: 30), flight!.apparentNewTimeOfDay(timeOfDay: TimeOfDay(hour:4, minute: 0)))
        XCTAssertEqual(TimeOfDay(hour:23, minute: 35), flight!.apparentNewTimeOfDay(timeOfDay: TimeOfDay(hour:5, minute: 5)))
    }
    
    func testApparentOldTimeOfDay() {
        XCTAssertEqual(TimeOfDay(hour:15, minute:30), flight!.apparentOldTimeOfDay(timeOfDay: TimeOfDay(hour:10, minute:0)))
        XCTAssertEqual(TimeOfDay(hour:4, minute:30), flight!.apparentOldTimeOfDay(timeOfDay: TimeOfDay(hour:23, minute:0)))
        XCTAssertEqual(TimeOfDay(hour:0, minute:5), flight!.apparentOldTimeOfDay(timeOfDay: TimeOfDay(hour:18, minute:35)))
    }
    
    func testTimeOfDayDifference() {
        let tod1 = TimeOfDay(hour: 10, minute: 30)
        let tod2 = TimeOfDay(hour: 11, minute: 15)
        XCTAssertEqual(TimeOfDayDelta(hour: 0, minute: 45), tod2 - tod1)
        
        XCTAssertEqual(TimeOfDayDelta(hour: 0, minute: 45), tod1.shortestDistanceTo(newTimeOfDay: tod2))
        XCTAssertEqual(TimeOfDayDelta(hour: 0, minute: -45), tod2.shortestDistanceTo(newTimeOfDay: tod1))
        
        XCTAssertEqual(TimeOfDayDelta(hour: 0, minute: 45), tod2.shortestDistanceTo(newTimeOfDay: tod1).absolute)
    }
    
    func testSimpleSchedule() {
        let tenDaysBefore = Calendar.current.date(byAdding: .day, value: -33, to: date_1973)
        let results = flight!.schedule(doses: [Dose(timeOfDay: TimeOfDay(hour: 12), pills:[pill!], context: context)], fromDate: tenDaysBefore!)
        XCTAssertEqual(33, results.count)
        XCTAssertEqual(tenDaysBefore, results[0].0)
        XCTAssertEqual(10, NSInteger(results[1].0.timeIntervalSince(results[0].0)) / 60 % 60)
    }
    
}








