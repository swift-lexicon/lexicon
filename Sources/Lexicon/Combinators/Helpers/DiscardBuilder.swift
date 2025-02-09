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
    ) -> DiscardBase<P.ParserType> {
        return DiscardBase(first.asParser)
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
        ) throws -> ParseResult<Void, P1.Input>? {
            if let remaining = try parser.parse(input)?.remaining {
                return ParseResult((), remaining)
            }
            
            return nil
        }
    }
}

extension DiscardBuilder.DiscardBase: InputPrinter where P1: Printer {
    @inlinable
    public func printWithRemaining(_ output: P1.Input) throws -> InputPrintResult<P1.Input>? {
        if let parseResult = try parser.parse(output),
           let printResult = try parser.print(parseResult.output) {
            return InputPrintResult(printResult, parseResult.remaining)
        }
        
        return nil
    }
}

extension DiscardBuilder.DiscardBase: VoidPrinter where P1: VoidPrinter {
    @inlinable
    public func print() throws -> P1.Input? {
        try parser.print()
    }
}

extension DiscardBuilder.DiscardBase: Sendable where P1: Sendable {}

public extension DiscardBuilder {
    @inlinable
    static func buildPartialBlock<P1: Parser, P2: ParserConvertible>(
        accumulated: P1,
        next: P2
    ) -> DiscardAccumulator<P1, P2.ParserType> {
        DiscardAccumulator(accumulated, next.asParser)
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
        ) throws -> ParseResult<Void, P1.Input>? {
            guard let remaining1 = try parser1.parse(input)?.remaining,
                  let remaining2 = try parser2.parse(remaining1)?.remaining else {
                return nil
            }
            
            return ParseResult((), remaining2)
        }
    }
}

extension DiscardBuilder.DiscardAccumulator: InputPrinter
where
    P1: InputPrinter,
    P2: Printer,
    P1.Input: Appendable
{
    @inlinable
    public func printWithRemaining(_ output: P1.Input) throws -> InputPrintResult<P1.Input>? {
        if let printResult = try parser1.printWithRemaining(output),
           let parseResult = try parser2.parse(printResult.remaining),
           let input2 = try parser2.print(parseResult.output) {
            var input = printResult.input
            input.append(contentsOf: input2)
            
            return InputPrintResult(input, parseResult.remaining)
        }
        
        return nil
    }
}

extension DiscardBuilder.DiscardAccumulator: VoidPrinter
where P1: VoidPrinter, P2: VoidPrinter, P1.Input: Appendable {
    @inlinable
    public func print() throws -> P1.Input? {
        if let input1 = try parser1.print(),
           let input2 = try parser2.print() {
            var input = input1
            input.append(contentsOf: input2)
            
            return input
        }
        
        return nil
    }
}

extension DiscardBuilder.DiscardAccumulator: Sendable where P1: Sendable, P2: Sendable {}
