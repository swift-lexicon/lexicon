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
        
        let parser = Repeat {
            Character("a")
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, repetitions)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testRepeatValidChildSucceedsForMinBound() throws {
        let repetitions = 2
        let input = Array(repeating: "a", count: repetitions).joined()
        
        let parser = Repeat(min: 2) {
            Character("a")
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, repetitions)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testRepeatValidChildSucceedsBetweenBound() throws {
        let repetitions = 3
        let input = Array(repeating: "a", count: repetitions).joined()
        
        let parser = Repeat(min: 2, max: 4) {
            Character("a")
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, repetitions)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testRepeatValidChildFailsLessThanMinBound() throws {
        let repetitions = 2
        let input = Array(repeating: "a", count: repetitions).joined()
        
        let parser = Repeat(min: 3, max: 4) {
            Character("a")
        }
        
        let result = try parser.parse(input)
                
        XCTAssertNil(result)
    }
    
    func testRepeatValidChildHasRemainderForMoreThanMaxBound() throws {
        let repetitions = 5
        let input = Array(repeating: "a", count: repetitions).joined()
        
        let parser = Repeat(min: 3, max: 4) {
            Character("a")
        }
        
        let result = try parser.parse(input)

        XCTAssertEqual(result?.output.count, 4)
        XCTAssertEqual(result?.remaining.count, 1)
    }
    
    func testRepeatWithSeparatorReturnsCorrectAmount() throws {
        let repetitions = 10
        let input = Array(repeating: "a", count: repetitions).joined(separator: ",")
        
        let parser = Repeat {
            Character("a")
        } separator: {
            ","
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, repetitions)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testRepeatWithSeparatorUntilReturnsCorrectAmount() throws {
        let input = "a,a,a,b"
        
        let parser = Repeat {
            Character("a")
        } separator: {
            ","
        } until: {
            "b"
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, 3)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testRepeatWithSeparatorUntilBoundsReturnsCorrectAmount() throws {
        let input = "a,a,a,b"
        
        let parser = Repeat(max: 3) {
            Character("a")
        } separator: {
            ","
        } until: {
            "b"
        }
        
        let result = try parser.parse(input)
                
        XCTAssertEqual(result?.output.count, 3)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testRepeatWithSeparatorUntilPrintsCorrectInput() throws {
        let input = "a,a,a,b"
        
        let parser = Repeat(max: 3) {
            Character("a")
        } separator: {
            ","
        } until: {
            "b"
        }
        
        let parseResult = try parser.parse(input)
        let printResult = try parser.print(parseResult!.output)
        
        XCTAssertEqual(input[...], printResult)
    }
    
    func testRepeatWithSeparatorPrintsCorrectInput() throws {
        let input = "a,a,a"
        
        let parser = Repeat(max: 3) {
            Character("a")
        } separator: {
            ","
        }
        
        let parseResult = try parser.parse(input)
        let printResult = try parser.print(parseResult!.output)
        
        XCTAssertEqual(input[...], printResult)
    }
    // Add repeat tests for different bounds, separator and until.
}
