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

    func testExample() {
        snapshot("0Launch")
    }

}
