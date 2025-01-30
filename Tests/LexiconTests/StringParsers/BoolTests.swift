import XCTest
import Lexicon

final class BoolTests: XCTestCase {
    func testBoolTrueSuccess() throws {
        let input = "true"
        let parser = bool
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, true)
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testBoolFalseSuccess() throws {
        let input = "false"
        let parser = bool
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, false)
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testBoolFailsOnNonBoolString() throws {
        let input = "null"
        let parser = bool
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
