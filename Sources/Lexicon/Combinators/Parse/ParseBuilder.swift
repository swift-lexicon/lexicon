//
//  ParseBuilder.swift
//  Lexicon
//
//  Created by Aaron Vranken on 25/01/2025.
//

@resultBuilder
public enum ParseBuilder { }

// Base cases
public extension ParseBuilder {
    @inlinable static func buildPartialBlock<P: CapturingParser>(first: P) -> ParseO<P> {
        return ParseO(first)
    }
    
    struct ParseO<P: CapturingParser>: Parser
    where
        P.Input: Collection,
        P.Input == P.Input.SubSequence
    {
        @usableFromInline let parser: P
        
        @inlinable public init(_ parser: P) {
            self.parser = parser
        }
        
        @inlinable public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
            if let result1 = try parser.parse(input) {
                return ParseResult(result1.output, result1.remaining)
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseO: Sendable where P: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildPartialBlock<P: ParserConvertible>(
        first: P
    ) -> ParseV<P.ParserType> {
        return ParseV(first.asParser)
    }
    
    struct ParseV<P: Parser>: Parser
    where P.Input: Collection, P.Input == P.Input.SubSequence {
        @usableFromInline let parser: P
        
        @inlinable public init(_ parser: P) {
            self.parser = parser
        }
        
        @inlinable public func parse(_ input: P.Input) throws -> ParseResult<Void, P.Input>? {
            if let result1 = try parser.parse(input) {
                return ParseResult((), result1.remaining)
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseV: Sendable where P: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildPartialBlock<P1: Parser, P2: ParserConvertible>(
        accumulated: P1,
        next: P2
    ) -> ParseVV<P1, P2.ParserType> {
        ParseVV(accumulated, next.asParser)
    }
    
    struct ParseVV<P1: Parser, P2: Parser>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence,
        P1.Input == P2.Input,
        P1.Output == ParseMatchWithoutCaptures<P1.Input>
    {
        @usableFromInline let parser1: P1, parser2: P2
        
        @inlinable public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable public func parse(_ input: P1.Input) throws -> ParseResult<Void, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult((), result2.remaining)
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseVV: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: CapturingParser>(
        accumulated: P1,
        next: P2
    ) -> ParseVO<P1, P2.ParserType> {
        ParseVO(accumulated, next.asParser)
    }
    
    struct ParseVO<P1: Parser, P2: Parser>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence,
        P1.Input == P2.Input,
        P1.Output == ParseMatchWithoutCaptures<P1.Input>
    {
        @usableFromInline let parser1: P1, parser2: P2
        
        @inlinable public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<P2.Output, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(result2.output, result2.remaining)
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseVO: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<
        P1: Parser,
        P2: CapturingParser,
        each P1Output
    >(
        accumulated: P1,
        next: P2
    ) -> ParseOO<P1, P2, (repeat each P1Output, P2.Output)>
    where
        P1.Output == (repeat each P1Output)
    {
        ParseOO(accumulated, next) { accumulatedCaptures, nextCapture in
            (repeat each accumulatedCaptures, nextCapture)
        }
    }

    struct ParseOO<P1: Parser, P2: CapturingParser, CaptureOutput>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence,
        P1.Input == P2.Input
    {
        @usableFromInline let parser1: P1, parser2: P2
        @usableFromInline let combine: @Sendable (P1.Output, P2.Output) -> CaptureOutput

        @inlinable public init(
            _ parser1: P1,
            _ parser2: P2,
            combine: @escaping @Sendable (P1.Output, P2.Output) -> CaptureOutput
        ) {
            self.parser1 = parser1
            self.parser2 = parser2
            self.combine = combine
        }

        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<CaptureOutput,P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(
                    combine(result1.output, result2.output),
                    result2.remaining
                )
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseOO: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildPartialBlock<
        P1: Parser,
        P2: ParserConvertible,
        each P1Output
    >(
        accumulated: P1,
        next: P2
    ) -> ParseOV<P1, P2.ParserType, (repeat each P1Output)>
    where
        P1.Output == (repeat each P1Output)
    {
        ParseOV(accumulated, next.asParser)
    }

    struct ParseOV<P1: Parser, P2: Parser, P1Output>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence,
        P1.Input == P2.Input,
        P1.Output == P1Output
    {
        @usableFromInline let parser1: P1, parser2: P2

        @inlinable public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }

        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<P1Output,P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(result1.output, result2.remaining)
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseOV: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildFinalResult<P1: Parser>(
        _ final: P1
    ) -> ParseFinalVoid<P1>
    where
        P1.Output == Void
    {
        ParseFinalVoid(final)
    }

    struct ParseFinalVoid<P1: Parser>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence
    {
        @usableFromInline let parser: P1

        @inlinable public init(_ parser: P1) {
            self.parser = parser
        }

        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<ParseMatchWithoutCaptures<P1.Input>, P1.Input>? {
            if let result = try parser.parse(input) {
                return ParseResult(
                    ParseMatchWithoutCaptures(
                        input[..<result.remaining.startIndex]
                    ),
                    result.remaining
                )
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseFinalVoid: Sendable where P1: Sendable {}


public extension ParseBuilder {
    @inlinable static func buildFinalResult<P1: Parser, each Capture>(
        _ final: P1
    ) -> ParseFinalCaptures<P1, (repeat each Capture)>
    where P1.Output == (repeat each Capture) {
        ParseFinalCaptures(final)
    }

    struct ParseFinalCaptures<P1: Parser, Captures>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence,
        P1.Output == Captures
    {
        @usableFromInline let parser: P1

        @inlinable public init(_ parser: P1) {
            self.parser = parser
        }

        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<ParseMatchWithCaptures<Captures, P1.Input>, P1.Input>? {
            if let result = try parser.parse(input) {
                return ParseResult(
                    ParseMatchWithCaptures(
                        input[..<result.remaining.startIndex],
                        result.output
                    ),
                    result.remaining
                )
            }
            return nil
        }
    }
}

extension ParseBuilder.ParseFinalCaptures: Sendable where P1: Sendable {}
