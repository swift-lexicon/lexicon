import XCTest
import Lexicon

final class MapTests: XCTestCase {
    func testMapFailsOnParserFail() throws {
        let input: [Int] = [1]
        let parser = Token<ArraySlice<Int>>(0)
            .map { $0.count }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
    
    func testMapSuccessOnParserSuccess() throws {
        let input: [Int] = [0]
        let parser = Token<ArraySlice<Int>>(0)
            .map { $0.count }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
}
