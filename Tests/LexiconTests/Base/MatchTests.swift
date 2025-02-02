
import XCTest
import Lexicon

final class MatchTests: XCTestCase {
    func testIdenticalMatchSuccessful() throws {
        let input = "match"
        let parser = Match("match")
        
        let result = try parser.parse(input)
        
        XCTAssertEqual(result?.output, "match")
        XCTAssertEqual(result?.remaining.isEmpty, true)
    }
    
    func testNonIdenticalMatchFails() throws {
        let input = "math"
        let parser = Match("matsj")
        
        let result = try parser.parse(input)
        
        XCTAssertNil(result)
    }
    
    func testSubmatchOfExtendedGraphemeClusterFails() throws {
        let input = "🏳️‍🌈"
        let parser = Match("🏳️")
        
        let result = try parser.parse(input)
        
        XCTAssertNil(result)
    }
    
    func testIdenticalMatchPrintSucceeds() throws {
        let input = "match"
        let parser = Match("match")
        
        let result = try parser.print(input[...])
        
        XCTAssertEqual(result, input[...])
    }
    
    func testNonIdenticalMatchPrintFails() throws {
        let input = "match"
        let parser = Match("match")
        
        let result = try parser.print(input[...])
        
        XCTAssertEqual(result, input[...])
    }
}
