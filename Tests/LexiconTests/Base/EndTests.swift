import XCTest
import Lexicon

final class EndTests: XCTestCase {
    func testEmptyCollectionSuccessful() throws {
        let input: [Int] = []
        let parser = End<[Int]>()
        
        let result = parser.parse(input)
        
        XCTAssertNotNil(result)
    }
    
    func testFullCollectionFails() throws {
        let input: [Int] = [1, 2, 3]
        let parser = End<[Int]>()
        
        let result = parser.parse(input)
        
        XCTAssertNil(result)
    }
    
    func testEmptySubSequenceSuccessful() throws {
        let input: [Int] = [1, 2, 3]
        let parser = End<ArraySlice<Int>>()
        
        let result = parser.parse(input[3...])
        
        XCTAssertNotNil(result)
    }
}
