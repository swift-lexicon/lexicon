import XCTest
import Lexicon

final class ClosureTests: XCTestCase {
    func testClosure() throws {
        let parse: @Sendable (_ input: Substring) -> ParseResult<
            Substring,
            Substring
        > = {
            let result = $0.prefix(while: { $0 == "a" })
            return ParseResult(result, $0[result.endIndex...])
        }
        
        let parser = Closure(parse)
        
        let repetitions = 10
        let input = Array(repeating: "a", count: repetitions).joined()
        
        let result = try parser.parse(input)
        
        XCTAssertEqual(result?.output.count, repetitions)
        XCTAssertEqual(result?.remaining.count, 0)
    }
}
