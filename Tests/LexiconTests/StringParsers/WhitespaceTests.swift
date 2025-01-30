import XCTest
import Lexicon

final class WhitespaceTests: XCTestCase {
    func testWhitespace() throws {
        let input = " \n\t\r"
        let parser = skipWhitespace
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, " \n\t\r")
        XCTAssertEqual(result?.remaining, "")
    }
}
