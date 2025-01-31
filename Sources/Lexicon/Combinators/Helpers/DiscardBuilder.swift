//
//  CaptureBuilder.swift
//  
//
//  Created by Aaron Vranken on 24/01/2025.
//

@resultBuilder
public enum DiscardBuilder {}

public extension DiscardBuilder {
    @inlinable
    static func buildPartialBlock<P: ParserConvertible>(
        first: P
    ) -> P.ParserType {
        return first.asParser
    }
    
    struct DiscardBase<P1: Parser>: Parser {
        @usableFromInline let parser: P1
        
        @inlinable
        public init(_ parser1: P1) {
            self.parser = parser1
        }
        
        @inlinable
        public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<Void, P1.Input>? {
            if let result = try parser.parse(input) {
                return ParseResult((), result.remaining)
            }
            
            return nil
        }
    }
}

extension DiscardBuilder.DiscardBase: Sendable where P1: Sendable {}

public extension DiscardBuilder {
    @inlinable
    static func buildPartialBlock<P1: ParserConvertible, P2: ParserConvertible>(
        accumulated: P1,
        next: P2
    ) -> DiscardAccumulator<P1, P2> {
        DiscardAccumulator(accumulated, next)
    }
    
    struct DiscardAccumulator<P1: Parser, P2: Parser>: Parser
    where
        P1.Input == P2.Input
    {
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
        ) throws -> ParseResult<(), P1.Input>? {
            guard let result1 = try parser1.parse(input),
                  let result2 = try parser2.parse(result1.remaining) else {
                return nil
            }
            
            return ParseResult((), result2.remaining)
        }
    }
}

extension DiscardBuilder.DiscardAccumulator: Sendable where P1: Sendable, P2: Sendable {}
