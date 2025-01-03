//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Матвей Сюзев on 12/28/24.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1,2,3,4,5,6]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1,2,3,4,5,6]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}
