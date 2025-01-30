import XCTest
import Lexicon

final class EndOfTests: XCTestCase {
    func testEndOfLineSuccess() throws {
        let input = "\n"
        let parser = endOfLine
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, "\n")
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testEndOfFileSuccess() throws {
        let input = ""
        let parser = endOfFile
        
        let result = parser.parse(input[...])
        
        XCTAssertNotNil(result?.output, "")
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testLineSingle() throws {
        let input = "line"
        let parser = line
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, "line")
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testLineMultiple() throws {
        let input = "line1\nline2\nline3"
        let parser = line
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, "line1")
        XCTAssertEqual(result?.remaining, "line2\nline3")
    }
}
