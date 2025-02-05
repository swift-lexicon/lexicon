//
//  ParseBuilder.swift
//  Lexicon
//
//  Created by Aaron Vranken on 25/01/2025.
//

@resultBuilder
public enum ParseBuilder { }

// The logic of the ParseBuilder is as follows:
// There are 4 Input -> Output options:
//
//   1. (WithoutCapture,    Non-Capturing)  -> WithoutCapture<DiscardBoth>
//   2. (WithCapture,       Non-Capturing)  -> WithCapture<CaptureFirst>
//   3. (WithoutCapture,    Capturing)      -> WithCapture<CaptureSecond>
//   4. (WithCapture,       Capturing)      -> WithCapture<CaptureBoth>
//

public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P: CapturingParser>(
        first: P
    ) -> WithCapture<P> {
        return WithCapture(first)
    }
    
    struct WithCapture<P: Parser> {
        @usableFromInline let parser: P

        @inlinable init(_ parser: P) {
            self.parser = parser
        }
    }
}

public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P: ParserConvertible>(
        first: P
    ) -> WithoutCapture<BaseWithoutCaptures<P.ParserType>> {
        return WithoutCapture(BaseWithoutCaptures(first.asParser))
    }
    
    struct WithoutCapture<P: Parser> {
        @usableFromInline let parser: P

        @inlinable init(_ parser: P) {
            self.parser = parser
        }
    }
    
    struct BaseWithoutCaptures<P: Parser>: Parser {
        @usableFromInline let parser: P

        @inlinable init(_ parser: P) {
            self.parser = parser
        }
        
        @inlinable
        public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
            try parser.parse(input)
        }
    }
}

extension ParseBuilder.BaseWithoutCaptures: Sendable where P: Sendable {}

//   1. (WithoutCapture,    Non-Capturing)  -> WithoutCapture<DiscardBoth>
public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: ParserConvertible>(
        accumulated: WithoutCapture<P1>,
        next: P2
    ) -> WithoutCapture<DiscardBoth<P1, P2.ParserType>> {
        return WithoutCapture(
            DiscardBoth(
                accumulated.parser,
                next.asParser
            )
        )
    }
    
    struct DiscardBoth<P1: Parser, P2: Parser>: Parser
    where P1.Input == P2.Input {
        @usableFromInline let parser1: P1
        @usableFromInline let parser2: P2
        
        @inlinable
        public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable
        public func parse(_ input: P1.Input) throws -> ParseResult<Void, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult((), result2.remaining)
            }
            
            return nil
        }
    }
}
extension ParseBuilder.DiscardBoth: Sendable
where P1: Sendable, P2: Sendable {}

//   2. (WithCapture,       Non-Capturing)  -> WithCapture<CaptureFirst>
public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: ParserConvertible>(
        accumulated: WithCapture<P1>,
        next: P2
    ) -> WithCapture<CaptureFirst<P1, P2.ParserType>> {
        return WithCapture(
            CaptureFirst(
                accumulated.parser,
                next.asParser
            )
        )
    }
    
    struct CaptureFirst<P1: Parser, P2: Parser>: Parser
    where P1.Input == P2.Input {
        @usableFromInline let parser1: P1
        @usableFromInline let parser2: P2
        
        @inlinable
        public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable
        public func parse(_ input: P1.Input) throws -> ParseResult<P1.Output, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(result1.output, result2.remaining)
            }
            
            return nil
        }
    }
}
extension ParseBuilder.CaptureFirst: Sendable
where P1: Sendable, P2: Sendable {}

//   3. (WithoutCapture,    Capturing)      -> WithCapture<CaptureSecond>
public extension ParseBuilder {
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: CapturingParser>(
        accumulated: WithoutCapture<P1>,
        next: P2
    ) -> WithCapture<CaptureSecond<P1, P2>> {
        return WithCapture(
            CaptureSecond(
                accumulated.parser,
                next
            )
        )
    }
    
    struct CaptureSecond<P1: Parser, P2: Parser>: Parser
    where P1.Input == P2.Input {
        @usableFromInline let parser1: P1
        @usableFromInline let parser2: P2
        
        @inlinable
        public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
        
        @inlinable
        public func parse(_ input: P1.Input) throws -> ParseResult<P2.Output, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(result2.output, result2.remaining)
            }
            
            return nil
        }
    }
}

extension ParseBuilder.CaptureSecond: Sendable
where P1: Sendable, P2: Sendable {}

//   4. (WithCapture,       Capturing)      -> WithCapture<CaptureBoth>
public extension ParseBuilder {    
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: CapturingParser, each P1Outputs>(
        accumulated: WithCapture<P1>,
        next: P2
    ) -> WithCapture<CaptureBoth<P1, P2, (repeat each P1Outputs, P2.Output)>>
    where P1.Output == (repeat each P1Outputs) {
        return WithCapture(
            CaptureBoth(
                accumulated.parser,
                next
            ) {
                (repeat each $0, $1)
            } separate: {
                unsafeBitCast($0, to: (P1.Output, P2.Output).self)
            }
        )
    }
    
    struct CaptureBoth<P1: Parser, P2: Parser, Captures>: Parser
    where P1.Input == P2.Input {
        @usableFromInline let parser1: P1
        @usableFromInline let parser2: P2
        @usableFromInline let combine: @Sendable (P1.Output, P2.Output) -> Captures
        @usableFromInline let separate: @Sendable (Captures) -> (P1.Output, P2.Output)
        
        @inlinable
        public init(
            _ parser1: P1,
            _ parser2: P2,
            combine: @escaping @Sendable (P1.Output, P2.Output) -> Captures,
            separate: @escaping @Sendable (Captures) -> (P1.Output, P2.Output)
        ) {
            self.parser1 = parser1
            self.parser2 = parser2
            self.combine = combine
            self.separate = separate
        }
        
        @inlinable
        public func parse(_ input: P1.Input) throws -> ParseResult<Captures, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(combine(result1.output, result2.output), result2.remaining)
            }
            
            return nil
        }
    }
}

extension ParseBuilder.CaptureBoth: Sendable
where P1: Sendable, P2: Sendable {}

public extension ParseBuilder {
    @inlinable
    static func buildFinalResult<P: Parser>(
        _ component: WithCapture<P>
    ) -> FinalWithCaptures<P> {
        return FinalWithCaptures(component.parser)
    }
    
    struct FinalWithCaptures<P: Parser>: Parser {
        @usableFromInline let parser: P
        
        @inlinable
        init(_ parser: P) {
            self.parser = parser
        }
        
        @inlinable
        public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
            try parser.parse(input)
        }
    }
}

extension ParseBuilder.FinalWithCaptures: Sendable where P: Sendable {}

public extension ParseBuilder {
    @inlinable
    static func buildFinalResult<P: Parser>(
        _ component: WithoutCapture<P>
    ) -> FinalWithoutCaptures<P> {
        return FinalWithoutCaptures(component.parser)
    }
    
    struct FinalWithoutCaptures<P: Parser>: Parser
    where P.Input: Collection, P.Input == P.Input.SubSequence {
        @usableFromInline let parser: P
        
        @inlinable
        init(_ parser: P) {
            self.parser = parser
        }
        
        @inlinable
        public func parse(_ input: P.Input) throws -> ParseResult<P.Input, P.Input>? {
            guard let result = try parser.parse(input) else {
                return nil
            }
            
            return ParseResult(input[..<result.remaining.startIndex], result.remaining)
        }
    }
}

extension ParseBuilder.FinalWithoutCaptures: Sendable where P: Sendable {}
