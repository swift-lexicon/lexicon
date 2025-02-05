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
        
        XCTAssertEqual(result?.output, [0])
    }
    
    func testParse2Capture() throws {
        let input: [Int] = [0, 1]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(1).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.0, [0])
        XCTAssertEqual(result?.output.1, [1])
    }
    
    func testParse3Capture() throws {
        let input: [Int] = [0, 1, 2]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(1).capture()
            Token<ArraySlice<Int>>(2).capture()
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output.0, [0])
        XCTAssertEqual(result?.output.1, [1])
        XCTAssertEqual(result?.output.2, [2])
    }
    
    func testParseVoidCapture() throws {
        let input: [Int] = [0, 1, 2]
        let parser = Parse {
            Token<ArraySlice<Int>>(0)
            Token<ArraySlice<Int>>(1).capture()
            Token<ArraySlice<Int>>(2)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1])
    }
    
    func testParseCaptureVoid() throws {
        let input: [Int] = [0, 1]
        let parser = Parse {
            Token<ArraySlice<Int>>(0).capture()
            Token<ArraySlice<Int>>(1)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [0])
    }
    
    func testParsePrint() throws {
        let input = "(aabbcc)"
        let parser = Parse {
            Character("(")
            SkipWhile { Not { Character(")") } }.capture()
            Character(")")
        }
        
        let parseResult = try parser.parse(input)
        let printResult = try parser.print(parseResult!.output)
    }
//    
    func testParseToMatchPrint() throws {
        let parser = Parse {
            Character("a")
            OneOrMore {
                Character("b")
            }
        }
        
        let input = "abbbbb"
        let parseResult = try! parser.parse(input)!
        let printResult = try! parser.print(parseResult.output)!
        
        XCTAssertEqual(input[...], printResult)
    }
}
