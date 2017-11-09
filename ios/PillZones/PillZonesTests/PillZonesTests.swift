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
    
    func testSimpleSchedule() {
        let tenDaysBefore = Calendar.current.date(byAdding: .day, value: -10, to: date_1973)
        let results = flight!.schedule(doses: [Dose(timeOfDay: TimeOfDay(hour: 12), pills:[pill!], context: context)], fromDate: tenDaysBefore!)
        XCTAssertEqual(10, results.count)
    }
    
}








