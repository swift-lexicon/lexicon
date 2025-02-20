//
//  Parse.swift
//  Lexicon
//
//  Created by Aaron Vranken on 23/01/2025.
//

/**
 # Description
 The `Parse` parser combines multiple parsers so that they are called in sequence on the input.
 If no captures are present as part of the `Parse` body, this will return the full subsequence that was consumed.
 If any of the parsers are captured in the `Parse` body, this will return a tuple of the captured values.
 */
public struct Parse<P: Parser>: Parser {
    @usableFromInline let parser: P
    
    @inlinable public init(@ParseBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        return try parser.parse(input)
    }
}

extension Parse: Sendable where P: Sendable {}

extension Parse: ParserPrinter & Printer
where P: Printer {
    @inlinable
    public func print(_ output: P.Output) throws -> P.Input? {
        try parser.print(output)
    }
}

public extension Parsers {
    typealias Parse = Lexicon.Parse
}
