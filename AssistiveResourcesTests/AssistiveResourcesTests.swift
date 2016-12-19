//
//  AssistiveResourcesTests.swift
//  AssistiveResourcesTests
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import XCTest
@testable import AssistiveResources

class AssistiveResourcesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateTimeDuration() {
        let eventDate = DateTimeDuration(yr: 2016, mo: 5, dy: 10, hr: 13, min: 0, durationMin: 30)
        XCTAssert(eventDate.whenDescription == "1pm-1:30pm")
        XCTAssert(eventDate.dayOfWeek == "TUE")
        XCTAssert(eventDate.monthAbbreviation == "MAY")
        XCTAssert(eventDate.day == 10)

        let eventDate2 = DateTimeDuration(yr: 1958, mo: 6, dy: 7, hr: 11, min: 30, durationMin: 120)
        XCTAssert(eventDate2.whenDescription == "11:30am-1:30pm")
        XCTAssert(eventDate2.dayOfWeek == "SAT")
        XCTAssert(eventDate2.monthAbbreviation == "JUN")
        XCTAssert(eventDate2.day == 7)
}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
