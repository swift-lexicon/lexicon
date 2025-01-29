import XCTest
import Lexicon

final class ZeroOrMoreTests: XCTestCase {
    func testZeroOrMoreEmptyCollectionSuccess() throws {
        let input: [Int] = []
        let parser = ZeroOrMore {
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testZeroOrMoreNoMatchSuccess() throws {
        let input: [Int] = [2, 3, 4]
        let parser = ZeroOrMore {
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.remaining.count, 3)
    }
    
    func testZeroOrMoreWithMatchReturnsCorrectAmount() throws {
        let input: [Int] = [1, 1, 1]
        let parser = ZeroOrMore {
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.count, 3)
        XCTAssertEqual(result?.remaining.count, 0)
    }
    
    // Add tests for separator and until
}
