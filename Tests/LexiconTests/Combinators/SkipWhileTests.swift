import XCTest
import Lexicon

final class SkipWhileTests: XCTestCase {
    func testSkipWhileEmptySuccess() throws {
        let input: [Int] = []
        let parser = SkipWhile {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testSkipWhileSuccessOnParserFail() throws {
        let input: [Int] = [1]
        let parser = SkipWhile {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testSkipWhileSuccessMatchesCorrectAmount() throws {
        let input: [Int] = [0, 0, 0, 1]
        let parser = SkipWhile {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [0, 0, 0])
        XCTAssertEqual(result?.remaining, [1])
    }
}
