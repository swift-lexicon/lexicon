//
//  Try.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 This is an optional parser.
 If the wrapper parser succeeds, this will return the same output value.
 If the wrapper parser fails, this will return a nil value.
 */
public struct Try<P: Parser>: Parser {
    @usableFromInline let parser: P
    
    public init(_ parser: P) {
        self.parser = parser
    }
    
    public init<PC: ParserConvertible>(_ builder: () -> PC)
    where P == PC.ParserType {
        self.parser = builder().asParser
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> ParseResult<P.Output?, P.Input>? {
        if let result = try parser.parse(input) {
            return ParseResult(result.output, result.remaining)
        }
        return ParseResult(nil, input)
    }
}

extension Try: ParserConvertible {
    public var asParser: Self {
        self
    }
}

extension Try: Sendable where P: Sendable {}
extension Try: CapturingParser where P: CapturingParser {}

public extension Parser {
    func optional() -> Try<Self> {
        Try(self)
    }
}
