import XCTest
import Lexicon

final class BetweenTests: XCTestCase {
    func testBetweenEmptyFails() throws {
        let input: [Int] = []
        let parser = Between {
            Token<ArraySlice<Int>>(0)
        } and: {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
    
    func testBetweenEmptyMiddleSuccess() throws {
        let input: [Int] = [0, 0]
        let parser = Between {
            Token<ArraySlice<Int>>(0)
        } and: {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [])
        XCTAssertEqual(result?.remaining, [])
    }
    
    func testBetweenGetsMiddleSuccess() throws {
        let input: [Int] = [0, 1, 1, 0]
        let parser = Between {
            Token<ArraySlice<Int>>(0)
        } and: {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1, 1])
        XCTAssertEqual(result?.remaining, [])
    }
}
