import XCTest
import Lexicon

final class TryTests: XCTestCase {
    func testTrySuccessOnParserFail() throws {
        let input: [Int] = [1]
        let parser = Try {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testTrySuccessOnParserSuccess() throws {
        let input: [Int] = [0]
        let parser = Try {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
}
