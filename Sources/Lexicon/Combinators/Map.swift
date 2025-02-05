//
//  Map.swift
//  Lexicon
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 This maps the output value of the wrapper parser to the output value of the transform function.
 */
public struct Map<P: Parser, Output, Invert>: Parser {
    @usableFromInline let parser: P
    @usableFromInline let transform: @Sendable (P.Output) throws -> Output
    @usableFromInline let invert: Invert?
    
    @inlinable public init(
        _ parser: P,
        _ transform: @Sendable @escaping ( P.Output) throws -> Output
    ) where Invert == Never {
        self.parser = parser
        self.transform = transform
        self.invert = nil
    }
    
    @inlinable public init(
        _ parser: P,
        _ transform: @Sendable @escaping (P.Output) throws -> Output,
        _ invert: @Sendable @escaping (Output) throws -> P.Output?
    ) where Invert == @Sendable (Output) throws -> P.Output? {
        self.parser = parser
        self.transform = transform
        self.invert = invert
    }

    @inlinable public func parse(_ input: P.Input) throws -> ParseResult<Output, P.Input>? {
        guard let result = try parser.parse(input) else {
            return nil
        }
        return ParseResult(try transform(result.output), result.remaining)
    }
}

public extension ParserConvertible {
    @inlinable func map<T>(
        _ transform: @Sendable @escaping (ParserType.Output) -> T
    ) -> Map<ParserType, T, Never> {
        Map(self.asParser, transform)
    }
    
    @inlinable func map<T>(
        _ transform: @Sendable @escaping (ParserType.Output) -> T,
        invert: @Sendable @escaping (T) throws -> ParserType.Output?
    ) -> Map<ParserType, T, @Sendable (T) throws -> ParserType.Output?> {
        Map(self.asParser, transform, invert)
    }
}

extension Map: ParserPrinter & Printer where
    Invert == @Sendable (Output) throws -> P.Output?,
    P: Printer
{
    @inlinable
    public func print(_ output: Output) throws -> P.Input? {
        guard let invert else {
            fatalError("Map does not have an invert method specified. This code should be unreachable.")
        }
        
        guard let inverted = try invert(output) else {
            return nil
        }
        
        return try parser.print(inverted)
    }
}

extension Map: CapturingParser where P: CapturingParser { }
extension Map: Sendable where P: Sendable, Invert: Sendable {}
