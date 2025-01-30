import XCTest
import Lexicon

final class NotTests: XCTestCase {
    func testNotSuccessOnParserFail() throws {
        let input: [Int] = [1]
        let parser = Not {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testNotFailsOnParserSuccess() throws {
        let input: [Int] = [0]
        let parser = Not {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
