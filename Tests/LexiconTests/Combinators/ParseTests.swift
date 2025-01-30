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
        
        XCTAssertNotNil(result)
    }
    
    func testParse2Capture() throws {
        let input: [Int] = [0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse3Capture() throws {
        let input: [Int] = [0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse4Capture() throws {
        let input: [Int] = [0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse5Capture() throws {
        let input: [Int] = [0, 0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse6Capture() throws {
        let input: [Int] = [0, 0, 0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse7Capture() throws {
        let input: [Int] = [0, 0, 0, 0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse8Capture() throws {
        let input: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse9Capture() throws {
        let input: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testParse10Capture() throws {
        let input: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(0).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
}
