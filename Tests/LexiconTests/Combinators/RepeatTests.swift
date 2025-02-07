//
//  RepeatTests.swift
//  Lexicon
//
//  Created by Aaron Vranken on 29/01/2025.
//
import XCTest
import Lexicon

final class RepeatTests: XCTestCase {
    func testRepeatValidChildReturnsCorrectAmount() throws {
        let repetitions = 10
        let input = Array(repeating: "a", count: repetitions).joined()
        
        let parser = Repeat(between: 0...) {
            Character("a")
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, repetitions)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    // Add repeat tests for different bounds, separator and until.
}
