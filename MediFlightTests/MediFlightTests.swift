//
//  PillZonesTests.swift
//  PillZonesTests
//
//  Created by Richard Hayes on 09/11/2017.
//  Copyright © 2017 Farming Online. All rights reserved.
//

import XCTest
import CoreData

@testable import MediFlight


class MediFlightTests: XCTestCase {
    
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
        XCTAssertEqual(TimeOfDay(hour:4, minute: 30), flight!.apparentNew(timeOfDay: TimeOfDay(hour:10, minute: 0)))
        XCTAssertEqual(TimeOfDay(hour:22, minute: 30), flight!.apparentNew(timeOfDay: TimeOfDay(hour:4, minute: 0)))
        XCTAssertEqual(TimeOfDay(hour:23, minute: 35), flight!.apparentNew(timeOfDay: TimeOfDay(hour:5, minute: 5)))
    }
    
    func testApparentOldTimeOfDay() {
        XCTAssertEqual(TimeOfDay(hour:15, minute:30), flight!.apparentOld(timeOfDay: TimeOfDay(hour:10, minute:0)))
        XCTAssertEqual(TimeOfDay(hour:4, minute:30), flight!.apparentOld(timeOfDay: TimeOfDay(hour:23, minute:0)))
        XCTAssertEqual(TimeOfDay(hour:0, minute:5), flight!.apparentOld(timeOfDay: TimeOfDay(hour:18, minute:35)))
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
        let thirtyThreeDaysBefore = Calendar.current.date(byAdding: .day, value: -33, to: date_1973)
        let doses = [Dose(timeOfDay: TimeOfDay(hour: 12), pills:[pill!], context: context)]
        let results = flight!.schedule(doses: doses, fromDate: thirtyThreeDaysBefore!, context: context)
        XCTAssertEqual(33, results.count)
        XCTAssertEqual(thirtyThreeDaysBefore, results[0].0)
        XCTAssertEqual(86400, NSInteger(results[1].0.timeIntervalSince(results[0].0)))
        XCTAssertEqual(TimeOfDayDelta(minutes:-10), results[1].1[0].timeOfDay - results[0].1[0].timeOfDay)
    }
    
    func testIsThroughNight() {
        XCTAssertFalse(TimeOfDay(hour: 12).isThroughNight(from: TimeOfDay(hour: 9)))
        XCTAssertFalse(TimeOfDay(hour: 9).isThroughNight(from: TimeOfDay(hour: 12)))
        XCTAssertTrue(TimeOfDay(hour: 22).isThroughNight(from: TimeOfDay(hour: 8)))
        XCTAssertTrue(TimeOfDay(hour: 8).isThroughNight(from: TimeOfDay(hour: 22)))
    }
    
    func testPreFlightDoses() {
        let dose = Dose(timeOfDay: TimeOfDay(hour: 9), pills:[pill!], context: context)
        let daysToFlight = 2
        let results = flight!.preFlightDoses(forDose: dose, withDays: daysToFlight, context: context)
        XCTAssertEqual(2, results.count)
    }
    
    func testTargetDose() {
        let dose = Dose(timeOfDay: TimeOfDay(hour: 10), pills:[pill!], context: context)
        XCTAssertEqual(TimeOfDay(hour:4, minute: 30), flight!.apparentNew(dose: dose, context: context).timeOfDay)
    }
    
    func testMatchDoses() {
        var doses = [Dose(timeOfDay: TimeOfDay(hour: 12), pills:[pill!], context: context)]
        let matches = flight!.matchDoses(originDoses:doses, targetDoses:doses.map { flight!.apparentNew(dose: $0, context: context) })
        XCTAssertEqual(1, matches.count)
        XCTAssertEqual(doses[0], matches[0].0)
        
        let flight9 = Flight(from: "Europe/London", to: "Asia/Seoul", on: date_1973 as NSDate, context: context)
        doses = [Dose(timeOfDay: TimeOfDay(hour: 10), pills:[pill!], context: context), Dose(timeOfDay: TimeOfDay(hour: 22), pills:[pill!], context: context)]
        let matches9 = flight9.matchDoses(originDoses:doses, targetDoses:doses.map { flight9.apparentNew(dose: $0, context: context) })
        XCTAssertEqual(matches9[0].0, doses[0])
        XCTAssertEqual(matches9[0].1.timeOfDay, flight9.apparentNew(timeOfDay: doses[1].timeOfDay))
        
        XCTAssertEqual(matches9[1].0, doses[1])
        XCTAssertEqual(matches9[1].1.timeOfDay, flight9.apparentNew(timeOfDay: doses[0].timeOfDay))
        
        
        doses = [Dose(timeOfDay: TimeOfDay(hour: 10), pills:[pill!, Pill(name: "Kepra", dosage: 50, context: context)], context: context), Dose(timeOfDay: TimeOfDay(hour: 22), pills:[pill!], context: context)]
        
        let nonmatches = flight9.matchDoses(originDoses:doses, targetDoses:doses.map { flight9.apparentNew(dose: $0, context: context) })
        XCTAssertEqual(nonmatches[0].0, doses[0])
        XCTAssertEqual(nonmatches[0].1.timeOfDay, flight9.apparentNew(timeOfDay: doses[0].timeOfDay))
        
        XCTAssertEqual(nonmatches[1].0, doses[1])
        XCTAssertEqual(nonmatches[1].1.timeOfDay, flight9.apparentNew(timeOfDay: doses[1].timeOfDay))
    }
    
    func testNightTimeSchedule() {
        let tenDaysBefore = Calendar.current.date(byAdding: .day, value: -10, to: date_1973)
        let doses = [Dose(timeOfDay: TimeOfDay(hour: 8), pills:[pill!], context: context)]
        let results = flight!.schedule(doses: doses, fromDate: tenDaysBefore!, context: context)
        XCTAssertEqual(21, results.count)
    }
    
}








