import XCTest
import Lexicon

final class ParseTests: XCTestCase {
    func testParse1Void() throws {
        let input: [Int] = [0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse2Void() throws {
        let input: [Int] = [0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0)
            Token<ArraySlice<Int>>(0)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse1Capture() throws {
        let input: [Int] = [0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.captures, [0])
    }
    
    func testParse2Capture() throws {
        let input: [Int] = [0, 1]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.captures.0, [0])
        XCTAssertEqual(result?.output.captures.1, [1])
    }
    
    func testParseVoidCapture() throws {
        let input: [Int] = [0, 1]
        let parser = Parse {
            Token<ArraySlice<Int>>(0)
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.captures, [1])
    }
    
    func testParseCaptureVoid() throws {
        let input: [Int] = [0, 1]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(1)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.captures, [0])
    }
}
