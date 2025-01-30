import XCTest
import Lexicon

enum TestError: Error {
    case failed
}

final class ThrowsTests: XCTestCase {
    func testThrowsOnParserFail() throws {
        let input: [Int] = [1]
        let parser = Token<ArraySlice<Int>>(0).throwOnFailure(TestError.failed)
        
        XCTAssertThrowsError(try parser.parse(input[...]))
    }
    
    func testDoesNotThrowOnParserSuccess() throws {
        let input: [Int] = [1]
        let parser = Token<ArraySlice<Int>>(1).throwOnFailure(TestError.failed)
        
        XCTAssertNoThrow(try parser.parse(input[...]))
    }
}
