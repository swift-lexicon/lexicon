import XCTest
import Lexicon

final class SpotTests: XCTestCase {
    func testTrueSpotSuccessful() throws {
        let input: [Int] = [1, 2, 3]
        let parser = Spot<ArraySlice<Int>> { $0 == 1 }
        
        let result = try parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1])
        XCTAssertEqual(result?.remaining.count, 2)
    }
    
    func testFalseSpotFails() throws {
        let input: [Int] = [1, 2, 3]
        let parser = Spot<ArraySlice<Int>> { $0 == 2 }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
