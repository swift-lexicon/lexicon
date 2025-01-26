import XCTest
import Parsecco

final class ParseccoTests: XCTestCase {
    func testStringMatchBaseline() throws {
        let input = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare nunc sed lacus tempor posuere. Proin lobortis imperdiet ex id varius. Praesent quis velit ultrices, tincidunt purus in, lacinia neque."
        let matchString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare nunc sed lacus tempor posuere. Proin lobortis imperdiet ex id varius. Praesent quis velit ultrices, tincidunt purus in, lacinia neque."
        
        var result: Substring?
        
        self.measure {
            for _ in (0..<1000000) {
                let matchee = matchString.prefix(input.count)
                if matchee == input {
                    result = matchee
                }
                result = nil
            }
        }
        
        print(result as Any)
    }
    
    // Performance using tuples: 1.34s
    func testMatchSpeed() throws {
        let input = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare nunc sed lacus tempor posuere. Proin lobortis imperdiet ex id varius. Praesent quis velit ultrices, tincidunt purus in, lacinia neque."
        let parser = Match("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare nunc sed lacus tempor posuere. Proin lobortis imperdiet ex id varius. Praesent quis velit ultrices, tincidunt purus in, lacinia neque.")
        
        var result: Substring?
        
        self.measure {
            for _ in (0..<1000000) {
                result = try! parser.parse(input)
            }
        }
        
        print(result as Any)
    }
    
    func testRecursiveParsing() throws {
        let input = "abababc"
        func recursive() -> some Parser<Substring, Substring> {
            return Parse {
                "a"
                "b"
                Lazy(recursive()).optional()
            }
        }
        
        let recursiveParser = recursive()
        
        XCTAssertEqual(try recursiveParser.parse(input), "ababab")
    }
    
    func testBetweenParser() throws {
        let input = "(abcd)"
        
        let parser = Between("(", and: ")")
        
        XCTAssertEqual(try parser.parse(input), "abcd")
    }
    
    func testScanner() throws {
        let input = "abcd"
        
        var result: Bool?
        self.measure {
            for _ in (0..<1000000) {
                result = input.contains("abcd")
            }
        }
        
        print(result as Any)
        
    }
    
    func testOneOf() throws {
        let input = "a"
        
        let oneOf1 = OneOf {
            "a"
        }
        
        let oneOf2 = OneOf {
            "b"
            "a"
        }
        
        let oneOf3 = OneOf {
            "c"
            "b"
            "a"
        }
        
        let result1 = try oneOf1.parse(input)
        XCTAssertEqual(result1, "a")
        
        let result2 = try oneOf2.parse(input)
        XCTAssertEqual(result2, "a")
        
        let result3 = try oneOf3.parse(input)
        XCTAssertEqual(result3, "a")
    }
    
    // Performance using tuples: 0.297s
    func testOneOf10Performance() throws {
        let input = "a"
        let oneOf10 = OneOf {
            "j"
            "i"
            "h"
            "g"
            "f"
            "e"
            "d"
            "c"
            "b"
            "a"
        }
        
        var result: Substring?
        self.measure {
            for _ in 0..<1000000 {
                result = try? oneOf10.parse(input)
            }
        }
        print(result)
    }
    
    // Performance using tuples: 0.364s
    func testZeroOrMore() throws {
        let input = "aaa"
        let zeroOrMore = ZeroOrMore {
            Match("a")
        }
        
        var result: [Substring]?
        self.measure {
            for _ in 0..<1000000 {
                result = try? zeroOrMore.parse(input)
            }
        }
        print(result)
    }
    
    // Performance using tuples: 0.0753s
    func testZeroOrMoreLength() throws {
        let input = Array(repeating: "a", count: 1000000).joined()
        let zeroOrMore = ZeroOrMore {
            Match("a")
        }
        
        var result: [Substring]?
        self.measure {
            result = try? zeroOrMore.parse(input)
        }
//        print(result)
    }
    
    // Performance using tuples: 0.521s
    func testZeroOrMoreUntil() throws {
        let input = "a,a,b,a"
        let zeroOrMore = ZeroOrMore {
            matchAlpha
        } separator: {
            ","
        } until: {
            "b"
        }
        
        var result: [Substring]?
        self.measure {
            for _ in 0..<1000000 {
                result = try? zeroOrMore.parse(input)
            }
        }
        print(result)
    }
    
    // Performance using tuples: 0.585s
    func testJsonParser() throws {
        let input = """
        { "title": "The Elements of Typographic Style" }
        """
        
        let jsonParser = JsonParser()
        
        var result: JsonValue?
        self.measure {
            for _ in 0..<10000 {
                result = try? jsonParser.parse(input)
            }
        }
        print(result)
    }
}
