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
    
    struct DiscardBase<P1: Parser>: Parser
    where P1.Input: Collection, P1.Input == P1.Input.SubSequence {
        @usableFromInline let parser: P1
        
        @inlinable
        public init(_ parser1: P1) {
            self.parser = parser1
        }
        
        @inlinable
        public func parse(
            _ input: P1.Input
        ) throws -> ParseResult<P1.Input, P1.Input>? {
            if let result = try parser.parse(input) {
                return ParseResult(input[..<result.remaining.startIndex], result.remaining)
            }
            
            return nil
        }
    }
}

extension DiscardBuilder.DiscardBase: PrinterWithRemaining & Printer where P1: Printer {
    @inlinable
    public func printWithRemaining(_ output: P1.Input) throws -> PrintResult<P1.Input, P1.Input>? {
        if let parseResult = try parser.parse(output),
           let printResult = try parser.print(parseResult.output) {
            return PrintResult(printResult, parseResult.remaining)
        }
        
        return nil
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
        P1.Input: Collection, P1.Input == P1.Input.SubSequence,
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
        ) throws -> ParseResult<P1.Input, P1.Input>? {
            guard let result1 = try parser1.parse(input),
                  let result2 = try parser2.parse(result1.remaining) else {
                return nil
            }
            
            return ParseResult(input[..<result2.remaining.startIndex], result2.remaining)
        }
    }
}

extension DiscardBuilder.DiscardAccumulator: PrinterWithRemaining & Printer
where
    P1: Printer,
    P2: Printer,
    P1.Input: Appendable
{
    public func printWithRemaining(_ output: P1.Input) throws -> PrintResult<P1.Input, P1.Input>? {
        if let parseResult1 = try parser1.parse(output),
           let parseResult2 = try parser2.parse(parseResult1.remaining),
           let input1 = try parser1.print(parseResult1.output),
           let input2 = try parser2.print(parseResult2.output) {
            var input = input1
            input.append(contentsOf: input2)
            
            return PrintResult(input, parseResult2.remaining)
        }
        
        return nil
    }
}

extension DiscardBuilder.DiscardAccumulator: Sendable where P1: Sendable, P2: Sendable {}
