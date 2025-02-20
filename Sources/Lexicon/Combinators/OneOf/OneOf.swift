//
//  OneOf.swift
//  Lexicon
//
//  Created by Aaron Vranken on 26/01/2025.
//

/**
 # Description
 The `OneOf` parser returns the result of the first successful subparser.
 */
public struct OneOf<P: Parser>: Parser {
    @usableFromInline let parser: P

    @inlinable
    public init(@OneOfBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        try parser.parse(input)
    }
}

extension OneOf: ParserPrinter & Printer where P: Printer {
    @inlinable
    public func print(_ output: P.Output) throws -> P.Input? {
        try parser.print(output)
    }
}

extension OneOf: Sendable where P: Sendable {}

public extension Parsers {
    typealias OneOf = Lexicon.OneOf
}
