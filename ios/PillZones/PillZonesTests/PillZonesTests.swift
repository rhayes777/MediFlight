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
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeZones() {
        let context = MockDatabaseManager().managedObjectContext()
        print(TimeZone.knownTimeZoneIdentifiers)
        let timeZone = TimeZone(identifier: "Asia/Katmandu")
        print(timeZone!.secondsFromGMT(for: Date(timeIntervalSince1970: 1000)))
        let date_1973 = Date(timeIntervalSince1970: 100000000)
        print(date_1973)
        print(TimeZone(identifier: "Europe/London")!.secondsFromGMT(for: date_1973))
        
        let flight = Flight(from: "Europe/London", to: "Asia/Katmandu", on: date_1973 as NSDate, context: context)
        XCTAssertEqual(date_1973, flight.on! as Date)
        XCTAssertEqual("Europe/London", flight.from!)
        XCTAssertEqual("Asia/Katmandu", flight.to!)
        XCTAssertEqual(19800, flight.timeDifference)
    }
    
}
