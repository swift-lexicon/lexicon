import XCTest
import Lexicon

final class OneOfTests: XCTestCase {
    func testOneOfSucceedsWithValidChild() throws {
        let input: [Int] = [1, 2, 3]
        let parser = OneOf {
            Token<ArraySlice<Int>>(3)
            Token<ArraySlice<Int>>(2)
            Token<ArraySlice<Int>>(1)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1])
        XCTAssertEqual(result?.remaining.count, 2)
    }
    
    func testOneOfFailsWithoutValidChild() throws {
        let input: [Int] = [1, 2, 3]
        let parser = OneOf {
            Token<ArraySlice<Int>>(4)
            Token<ArraySlice<Int>>(3)
            Token<ArraySlice<Int>>(2)
        }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
