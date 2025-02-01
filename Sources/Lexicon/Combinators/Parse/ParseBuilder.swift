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
    @inlinable static func buildPartialBlock<P: CapturingParser>(first: P) -> WithCapture<P> {
        return WithCapture(first)
    }
    
    struct WithCapture<P: Parser>: Parser {
        @usableFromInline let parser: P
        
        @inlinable init(_ parser: P) {
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

extension ParseBuilder.WithCapture: Sendable where P: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildPartialBlock<P: ParserConvertible>(
        first: P
    ) -> WithoutCapture<P.ParserType> {
        return WithoutCapture(first.asParser)
    }
    
    struct WithoutCapture<P: Parser>: Parser {
        @usableFromInline let parser: P
        
        @inlinable init(_ parser: P) {
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

extension ParseBuilder.WithoutCapture: Sendable where P: Sendable {}

public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: ParserConvertible>(
        accumulated: WithoutCapture<P1>,
        next: P2
    ) -> WithoutCapture<CaptureFirst<P1, P2.ParserType>> {
        WithoutCapture(CaptureFirst(accumulated.parser, next.asParser))
    }
    
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: ParserConvertible>(
        accumulated: WithCapture<P1>,
        next: P2
    ) -> WithCapture<CaptureFirst<P1, P2.ParserType>> {
        WithCapture(CaptureFirst(accumulated.parser, next.asParser))
    }
    
    struct CaptureFirst<P1: Parser, P2: Parser>: Parser
    where P1.Input == P2.Input {
        @usableFromInline let parser1: P1, parser2: P2
        
        @inlinable init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<P1.Output, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(result1.output, result2.remaining)
            }
            return nil
        }
    }
}

extension ParseBuilder.CaptureFirst: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildPartialBlock<P1: Parser, P2: CapturingParser>(
        accumulated: WithoutCapture<P1>,
        next: P2
    ) -> WithCapture<CaptureSecond<P1, P2.ParserType>> {
        WithCapture(CaptureSecond(accumulated.parser, next.asParser))
    }

    struct CaptureSecond<P1: Parser, P2: Parser>: Parser
    where P1.Input == P2.Input {
        @usableFromInline let parser1: P1, parser2: P2

        @inlinable init(_ parser1: P1, _ parser2: P2) {
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

extension ParseBuilder.CaptureSecond: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<
        P1: Parser,
        P2: CapturingParser,
        each P1Output
    >(
        accumulated: WithCapture<P1>,
        next: P2
    ) -> WithCapture<
        CaptureBoth<P1, P2>.CombineBoth<(repeat each P1Output, P2.Output)>
    > where
        P1.Output == (repeat each P1Output)
    {
        WithCapture(
            CaptureBoth(accumulated.parser, next).combine { accumulatedCaptures, nextCapture in
                (repeat each accumulatedCaptures, nextCapture)
            }
        )
    }

    struct CaptureBoth<P1: Parser, P2: Parser>: Parser
    where
        P1.Input == P2.Input
    {
        @usableFromInline let parser1: P1, parser2: P2

        @inlinable init(
            _ parser1: P1,
            _ parser2: P2
        ) {
            self.parser1 = parser1
            self.parser2 = parser2
        }

        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<(P1.Output, P2.Output), P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(
                    (result1.output, result2.output),
                    result2.remaining
                )
            }
            return nil
        }
    }
}

extension ParseBuilder.CaptureBoth: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder.CaptureBoth {
    struct CombineBoth<Captures>: Parser {
        @usableFromInline let parser: ParseBuilder.CaptureBoth<P1, P2>
        @usableFromInline let combine: @Sendable (P1.Output, P2.Output) -> Captures
        
        @inlinable init(
            _ parser: ParseBuilder.CaptureBoth<P1, P2>,
            _ combine: @Sendable @escaping (P1.Output, P2.Output) -> Captures
        ) {
            self.parser = parser
            self.combine = combine
        }
        
        @inlinable
        public func parse(_ input: P1.Input) throws -> ParseResult<Captures, P1.Input>? {
            if let result = try parser.parse(input) {
                return ParseResult(combine(result.output.0, result.output.1), result.remaining)
            }
            return nil
        }
    }
    
    @inlinable
    func combine<Captures>(_ combine:  @Sendable @escaping (P1.Output, P2.Output) -> Captures) -> CombineBoth<Captures> {
        .init(self, combine)
    }
}

extension ParseBuilder.CaptureBoth.CombineBoth: Sendable where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable static func buildFinalResult<P1: Parser>(
        _ parser: WithoutCapture<P1>
    ) -> ParseFinalVoid<P1> {
        ParseFinalVoid(parser.parser)
    }

    struct ParseFinalVoid<P1: Parser>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence
    {
        @usableFromInline let parser: P1

        @inlinable init(_ parser: P1) {
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
    @inlinable static func buildFinalResult<P1: Parser>(
        _ parser: WithCapture<P1>
    ) -> ParseFinalCaptures<P1> {
        ParseFinalCaptures(parser.parser)
    }

    struct ParseFinalCaptures<P1: Parser>: Parser
    where
        P1.Input: Collection,
        P1.Input == P1.Input.SubSequence
    {
        @usableFromInline let parser: P1

        @inlinable init(_ parser: P1) {
            self.parser = parser
        }

        @inlinable public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<ParseMatchWithCaptures<P1.Output, P1.Input>, P1.Input>? {
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
