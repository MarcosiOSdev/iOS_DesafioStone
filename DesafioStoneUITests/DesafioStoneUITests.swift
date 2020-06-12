//
//  DesafioStoneUITests.swift
//  DesafioStoneUITests
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import XCTest

class DesafioStoneUITests: XCTestCase {

    
    var app: XCUIApplication!
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func testNavigation() {
        
        snapshot("init_view")
        XCTAssertTrue(true)
        app.buttons["searchBarItem"].tap()
        snapshot("search_view")
//
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery.collectionViews.staticTexts["GAMES"].tap()
//
//        snapshot("tap_in_suggestion_element")
//
//
//        chuckNorrisFactsNavigationBar.buttons["Search"].tap()
//        elementsQuery.textFields["Search"].tap()
//        elementsQuery.textFields["Search"].typeText("Test")
//        app.buttons["Return"].tap()
//
//        snapshot("search_test")
//
//        chuckNorrisFactsNavigationBar.buttons["Chuck Norris Facts"].tap()
//        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Horses have long faces because they keep challenging Chuck Norris to \"whos got the biggest dick\" contests.").buttons["icon shared"].tap()
//
//
//        snapshot("sharing_some_thing")
//
//        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
//        snapshot("close_activity_content")
    }
}
