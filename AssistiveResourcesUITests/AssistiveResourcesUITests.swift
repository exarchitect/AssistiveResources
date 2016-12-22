//
//  AssistiveResourcesUITests.swift
//  AssistiveResourcesUITests
//
//  Created by Bill Johnson on 11/18/16.
//  Copyright © 2016 SevenPlusTwo. All rights reserved.
//

import XCTest

class AssistiveResourcesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        
        let okButton = app.buttons["OK"]
        okButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Regional and national events in your area"].tap()
        tablesQuery.staticTexts["Best Buddies Spring Gala"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Come to the event of the season - our spring gala celebration.  This is a grand opportunity to socialize and make friends, party, and generally have a great time.").buttons["Details"].tap()
        
        let backButton = app.buttons["Back"]
        backButton.tap()
        app.buttons["settings"].tap()
        okButton.tap()
        backButton.tap()
        
    }
    
}
