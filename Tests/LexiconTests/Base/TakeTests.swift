import XCTest
import Lexicon

final class TakeTests: XCTestCase {
    func testTake1() throws {
        let input: [Int] = [1, 2, 3]
        let parser = Take<ArraySlice<Int>>(1)
        
        let result = parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1])
        XCTAssertEqual(result?.remaining.count, 2)
    }
    
    func testTakeMultiple() throws {
        let input: [Int] = [1, 2, 3]
        let parser = Take<ArraySlice<Int>>(2)
        
        let result = parser.parse(input[...])
        
        XCTAssertEqual(result?.output, [1, 2])
        XCTAssertEqual(result?.remaining.count, 1)
    }
    
    func testTake1EmptyFails() throws {
        let input: [Int] = []
        let parser = Take<ArraySlice<Int>>(1)
        
        let result = parser.parse(input[...])
        
        XCTAssertNil(result)
    }
    
    func testTakeMultipleEmptyFails() throws {
        let input: [Int] = []
        let parser = Take<ArraySlice<Int>>(2)
        
        let result = parser.parse(input[...])
        
        XCTAssertNil(result)
    }
}
