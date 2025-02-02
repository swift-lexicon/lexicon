import XCTest
import Lexicon

final class MapTests: XCTestCase {
    func testMapFailsOnParserFail() throws {
        let input: [Int] = [1]
        let parser = Token<ArraySlice<Int>>(0)
            .map { $0.count }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNil(result)
    }
    
    func testMapSuccessOnParserSuccess() throws {
        let input: [Int] = [0]
        let parser = Token<ArraySlice<Int>>(0)
            .map { $0.count }
        
        let result = try parser.parse(input[...])
        
        XCTAssertNotNil(result)
    }
    
    func testMapPrint() throws {
        let input = "abc"
        let parser = Match("abc").map {
            $0.count
        } invert: { _ in
            return "abc"
        }
        
        let result = try parser.parse(input)
        let printResult = try parser.print(result!.output)
                
        XCTAssertNotNil(result)
    }
}
