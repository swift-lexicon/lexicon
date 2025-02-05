//
//  Parse.swift
//  Lexicon
//
//  Created by Aaron Vranken on 23/01/2025.
//

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
