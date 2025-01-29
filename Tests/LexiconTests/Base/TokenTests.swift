import XCTest
import Lexicon

final class TokenTests: XCTestCase {
    func testIdenticalTokenSuccessful() throws {
        let input: [Int] = [1, 2, 3]
        let parser = Token<ArraySlice<Int>>(1)
        
        let result = parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1])
        XCTAssertEqual(result?.remaining.count, 2)
    }
    
    func testDifferentTokenFails() throws {
        let input: [Int] = [1, 2, 3]
        let parser = Token<ArraySlice<Int>>(2)
        
        let result = parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
