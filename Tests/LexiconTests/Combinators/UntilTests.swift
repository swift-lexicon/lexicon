import XCTest
import Lexicon

final class UntilTests: XCTestCase {
    func testUntilSuccessOnParserSuccess() throws {
        let input: [Int] = [0, 1]
        let parser = Until {
            Token<ArraySlice<Int>>(1)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [0])
        XCTAssertEqual(result?.remaining, [])
    }
    
    func testUntilFailOnParserFail() throws {
        let input: [Int] = [0, 0]
        let parser = Until {
            Token<ArraySlice<Int>>(1)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
