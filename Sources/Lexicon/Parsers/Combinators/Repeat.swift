//
//  Repeat.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation

public struct Repeat<P: Parser>: Parser {
    @usableFromInline let parser: P
    @usableFromInline let lowerBound: Int?
    @usableFromInline let upperBound: Int?
    
    @inlinable init(lowerBound: Int?, upperBound: Int?, parser: P) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.parser = parser
    }
    
    @inlinable
    public init(
        between: ClosedRange<Int>,
        _ parser: P
    ) {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: between.upperBound,
            parser: parser
        )
    }
    
    @inlinable
    public init(
        between: ClosedRange<Int>,
        @ParserBuilder _ builder: () -> P
    ) {
        self.init(between: between, builder())
    }
    
    @inlinable
    public init(
        between: PartialRangeFrom<Int>,
        _ parser: P
    ) {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: nil,
            parser: parser
        )
    }
    
    @inlinable
    public init(
        between: PartialRangeFrom<Int>,
        @ParserBuilder _ builder: () -> P
    ) {
        self.init(between: between, builder())
    }
    
    @inlinable
    public init(
        between: PartialRangeThrough<Int>,
        _ parser: P
    ) {
        self.init(
            lowerBound: nil,
            upperBound: between.upperBound,
            parser: parser
        )
    }
    
    @inlinable
    public init(
        between: PartialRangeThrough<Int>,
        @ParserBuilder _ builder: () -> P
    ) {
        self.init(between: between, builder())
    }
    
    @inlinable
    public init(times: Int, _ parser: P) {
        self.init(between: times...times, parser)
    }
    
    @inlinable
    public init(times: Int, @ParserBuilder _ builder: () -> P) {
        self.init(times: times, builder())
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<[P.Output], P.Input>? {
        var results: [P.Output] = []
        var remaining = input
        var i = 0
        while
            upperBound.map({ i < $0 }) == true,
            let result = try parser.parse(input)
        {
            results.append(result.output)
            remaining = result.remaining
            i += 1
        }
        
        guard lowerBound.map({ i >= $0 }) == true || upperBound.map({ i <= $0 }) == true else {
            return nil
        }
        
        return ParseResult(results, remaining)
    }
}

extension Parser {
    @inlinable
    public func repeating(times: Int) -> Repeat<Self> {
        return Repeat(times: times, self)
    }
    
    @inlinable
    public func repeating(between: ClosedRange<Int>) -> Repeat<Self> {
        return Repeat(between: between, self)
    }
}

extension Repeat: Sendable where P: Sendable {}
