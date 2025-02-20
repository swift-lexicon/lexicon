import XCTest
import Lexicon

final class NumberTests: XCTestCase {
    func testMatchNaturalNumberCannotStartWithZero() throws {
        let input = "01234"
        
        let result = try matchNaturalNumber.parse(input)
        
        XCTAssertEqual(result?.output, 0)
        XCTAssertEqual(result?.remaining, "1234")
    }
    
    func testMatchNaturalNumberSuccess() throws {
        let input = "1234"
        
        let result = try matchNaturalNumber.parse(input)
        
        XCTAssertEqual(result?.output, 1234)
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testNegativeNumberCannotStartWithZero() throws {
        let input = "-01234"
        
        let result = try matchNegativeNumber.parse(input)
        
        XCTAssertNil(result)
    }
    
    func testNegativeNumberSuccess() throws {
        let input = "-1234"
        
        let result = try matchNegativeNumber.parse(input)
        
        XCTAssertEqual(result?.output, -1234)
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testIntegerSuccessNatural() throws {
        let input = "1234"
        
        let result = try matchInteger.parse(input)
        
        XCTAssertEqual(result?.output, 1234)
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testIntegerZeroSucceeds() throws {
        let input = "0"
        
        let result = try matchInteger.parse(input)
        
        XCTAssertEqual(result?.output, 0)
        XCTAssertEqual(result?.remaining, "")
    }
    
    func testIntegerNegativeZeroFails() throws {
        let input = "-0"
        
        let result = try matchInteger.parse(input)
        
        XCTAssertNil(result)
    }
    
    func testIntegerSuccessNegative() throws {
        let input = "-1234"
        
        let result = try matchInteger.parse(input)
        
        XCTAssertEqual(result?.output, -1234)
        XCTAssertEqual(result?.remaining, "")
    }
}
