//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Матвей Сюзев on 12/29/24.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(3)
        
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation
        let buttonYes = app.buttons["Yes"]
        
        buttonYes.tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertEqual(indexLabel, "2/10")
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testNoButton() throws {
        sleep(3)
        
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation
        let buttonNo = app.buttons["No"]
        
        buttonNo.tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertEqual(indexLabel, "2/10")
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testAlertResults() throws {
        sleep(3)
        
        let buttonYes = app.buttons["Yes"]
        
        for _ in 1...10 {
            buttonYes.tap()
            sleep(3)
        }
        
        sleep(2)
        
        let alertResults = app.alerts["ResultsAlert"]
        
        XCTAssertTrue(alertResults.exists)
        
        let alertTitle = alertResults.label
        let alertButtonTextPlayAgain = alertResults.buttons["Сыграть еще раз"]
        let alertButtonTextReset = alertResults.buttons["Сбросить статистику"]
        
        XCTAssertEqual(alertTitle, "Этот раунд окончен!")
        XCTAssertTrue(alertButtonTextPlayAgain.exists)
        XCTAssertTrue(alertButtonTextReset.exists)
    }
    
    func testPlayAgainDismissAlert() throws {
        sleep(2)
        
        let buttonYes = app.buttons["Yes"]
        
        for _ in 1...10 {
            buttonYes.tap()
            sleep(3)
        }
        
        sleep(2)
        
        let alertResults = app.alerts["ResultsAlert"]
        
        if alertResults.exists {
            alertResults.buttons["Сыграть еще раз"].tap()
        }
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertFalse(alertResults.exists)
        XCTAssertEqual(indexLabel, "1/10")
    }
    
    func testResetStatDismissAlert() throws {
        sleep(2)
        
        let buttonYes = app.buttons["Yes"]
        
        for _ in 1...10 {
            buttonYes.tap()
            sleep(3)
        }
        
        sleep(2)
        
        let alertResults = app.alerts["ResultsAlert"]
        
        if alertResults.exists {
            alertResults.buttons["Сбросить статистику"].tap()
        }
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"].label
        
        XCTAssertFalse(alertResults.exists)
        XCTAssertEqual(indexLabel, "1/10")
    }

    @MainActor
    func testExample() throws {

        let app = XCUIApplication()
        app.launch()
    }
}
