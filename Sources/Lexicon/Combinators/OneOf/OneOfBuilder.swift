//
//  OneOfBuilder.swift
//  Lexicon
//
//  Created by Aaron Vranken on 26/01/2025.
//

@resultBuilder
public enum OneOfBuilder {}

public extension OneOfBuilder {
    @inlinable
    static func buildPartialBlock<P: ParserConvertible>(
        first: P
    ) -> P.ParserType {
        return first.asParser
    }
}

public extension OneOfBuilder {
    @inlinable
    static func buildPartialBlock<P1: ParserConvertible, P2: ParserConvertible>(
        accumulated: P1,
        next: P2
    ) -> OneOfAccumulator<P1.ParserType, P2.ParserType> {
        OneOfAccumulator(accumulated.asParser, next.asParser)
    }
    
    struct OneOfAccumulator<P1: Parser, P2: Parser>: Parser
    where P1.Input == P2.Input, P1.Output == P2.Output {
        @usableFromInline let parser1: P1
        @usableFromInline let parser2: P2
        
        @inlinable
        public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable
        public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<P1.Output, P1.Input>? {
            if let result = try parser1.parse(input) {
                return result
            }
            return try parser2.parse(input)
        }
    }
}

extension OneOfBuilder.OneOfAccumulator: Printer where P1: Printer, P2: Printer {
    @inlinable
    public func print(_ output: P1.Output) throws -> P1.Input? {
        if let result = try parser1.print(output) {
            return result
        }
        return try parser2.print(output)
    }
}

extension OneOfBuilder.OneOfAccumulator: Sendable
where P1: Sendable, P2: Sendable {}
