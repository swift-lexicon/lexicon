//
//  ParseBuilder.swift
//  Lexicon
//
//  Created by Aaron Vranken on 25/01/2025.
//

@attached(member, names: arbitrary)
macro generateParseBuilderMembers() = #externalMacro(module: "LexiconMacros", type: "GenerateParseBuilderMembers")

@resultBuilder
public enum ParseBuilder { }

// Base cases
public extension ParseBuilder {
    @inlinable static func buildPartialBlock<P: CapturingParser>(first: P) -> ParseO<P>
    where P.Input: Collection, P.Input == P.Input.SubSequence {
        return ParseO(first)
    }
    
    @parseSendableConformanceMacro
    struct ParseO<P: Parser>: Parser
    where P.Input: Collection, P.Input == P.Input.SubSequence {
        @usableFromInline let parser: P
    
        @inlinable public init(_ parser: P) {
            self.parser = parser
        }
    
        @inlinable public func parse(_ input: P.Input) throws -> ParseResult<ParseMatchWithCaptures<P.Output, P.Input>, P.Input>? {
            if let result1 = try parser.parse(input) {
                return ParseResult(ParseMatchWithCaptures(input[input.startIndex ..< result1.remaining.startIndex], result1.output), result1.remaining)
            }
            return nil
        }
    }
    
    @inlinable static func buildPartialBlock<P: ParserConvertible>(first: P) -> ParseV<P.ParserType>
    where P.ParserType.Input: Collection, P.ParserType.Input == P.ParserType.Input.SubSequence {
        return ParseV(first.asParser)
    }

    @parseSendableConformanceMacro
    struct ParseV<P: Parser>: Parser
    where P.Input: Collection, P.Input == P.Input.SubSequence {
        @usableFromInline let parser: P

        @inlinable public init(_ parser: P) {
            self.parser = parser
        }

        @inlinable public func parse(_ input: P.Input) throws -> ParseResult<ParseMatchWithoutCaptures<P.Input>, P.Input>? {
            if let result1 = try parser.parse(input) {
                return ParseResult(ParseMatchWithoutCaptures(input[input.startIndex ..< result1.remaining.startIndex]), result1.remaining)
            }
            return nil
        }
    }
    
    @inlinable static func buildPartialBlock<P0: Parser, P1: ParserConvertible>(accumulated: P0, next: P1) -> ParseVVAccumulator<P0, P1.ParserType> {
        ParseVVAccumulator(accumulated, next.asParser)
    }

    @parseSendableConformanceMacro
    struct ParseVVAccumulator<P1: Parser, P2: Parser>: Parser
    where P1.Input: Collection, P1.Input == P1.Input.SubSequence, P1.Input == P2.Input, P1.Output == ParseMatchWithoutCaptures<P1.Input> {
        @usableFromInline let parser1: P1, parser2: P2
    
        @inlinable public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }
    
        @inlinable public func parse(_ input: P1.Input) throws -> ParseResult<ParseMatchWithoutCaptures<P1.Input>, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(ParseMatchWithoutCaptures(input[input.startIndex ..< result2.remaining.startIndex]), result2.remaining)
            }
            return nil
        }
    }
    
    @inlinable static func buildPartialBlock<P1: Parser, P2: CapturingParser>(accumulated: P1, next: P2) -> ParseVOAccumulator<P1, P2>
    where P1.Input == P2.Input {
        ParseVOAccumulator(accumulated, next)
    }
                
    @parseSendableConformanceMacro
    struct ParseVOAccumulator<P1: Parser, P2: Parser>: Parser
    where P1.Input: Collection, P1.Input == P1.Input.SubSequence, P1.Input == P2.Input, P1.Output == ParseMatchWithoutCaptures<P1.Input> {
        @usableFromInline let parser1: P1, parser2: P2

        @inlinable public init(_ parser1: P1, _ parser2: P2) {
            self.parser1 = parser1
            self.parser2 = parser2
        }

        @inlinable public func parse(_ input: P1.Input) throws -> ParseResult<ParseMatchWithCaptures<P2.Output, P1.Input>, P1.Input>? {
            if let result1 = try parser1.parse(input),
               let result2 = try parser2.parse(result1.remaining) {
                return ParseResult(ParseMatchWithCaptures(input[input.startIndex ..< result2.remaining.startIndex], result2.output), result2.remaining)
            }
            return nil
        }
    }
}

// Automatically generated OutputAccumulators
@generateParseBuilderMembers
public extension ParseBuilder { }
