import XCTest
import Lexicon

final class OneOrMoreTests: XCTestCase {
    func testOneOrMoreEmptyCollectionFails() throws {
        let input: [Int] = []
        let parser = OneOrMore {
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
    
    func testOneOrMoreNoMatchSuccess() throws {
        let input: [Int] = [2, 3, 4]
        let parser = ZeroOrMore {
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.remaining.count, 3)
    }
    
    func testOneOrMoreWithMatchReturnsCorrectAmount() throws {
        let input: [Int] = [1, 1, 1]
        let parser = ZeroOrMore {
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.count, 3)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testOneOrMoreWithSeparator() throws {
        let input: [Int] = [1, 0, 1, 0, 1]
        let parser = OneOrMore {
            Token<ArraySlice<Int>>(1).capture()
        } separator: {
            Token<ArraySlice>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.count, 3)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    func testOneOrMoreWithUntil() throws {
        let input: [Int] = [1, 1, 1, 1, 0, 1]
        let parser = OneOrMore {
            Take<ArraySlice<Int>>(1)
        } until: {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.count, 4)
        XCTAssertEqual(result?.remaining.count, 1)
    }
    
    // Add tests for separator and until
}
