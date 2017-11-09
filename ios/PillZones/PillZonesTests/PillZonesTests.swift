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
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil,
                                                              at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeZones() {
        print(TimeZone.knownTimeZoneIdentifiers)
        let timeZone = TimeZone(identifier: "Asia/Katmandu")
        print(timeZone!.secondsFromGMT(for: Date(timeIntervalSince1970: 1000)))
        let date_1973 = Date(timeIntervalSince1970: 100000000)
        print(date_1973)
        print(TimeZone(identifier: "Europe/London")!.secondsFromGMT(for: date_1973))
        
        let flight = Flight.make(from: "Europe/London", to: "Asia/Katmandu", on: date_1973 as NSDate, context: self.setUpInMemoryManagedObjectContext())
        XCTAssertEqual(date_1973, flight.on! as Date)
        XCTAssertEqual("Europe/London", flight.from!)
        XCTAssertEqual("Asia/Katmandu", flight.to!)
        XCTAssertEqual(19800, flight.timeDifference)
    }
    
}
