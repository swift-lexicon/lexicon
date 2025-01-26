//
//  ZeroOrMore.swift
//
//
//  Created by Aaron Vranken on 26/01/2025.
//

import Foundation

public struct ZeroOrMore<P: Parser, Separator: Parser, Until: Parser>: Parser
where P.Input == Separator.Input, P.Input == Until.Input {
    @usableFromInline let parser: P
    @usableFromInline let separator: Separator?
    @usableFromInline let until: Until?

    @inlinable
    public init(@ParseBuilder builder: () -> P)
    where Separator == NeverParser<Input>, Until == NeverParser<Input> {
        self.parser = builder()
        self.separator = nil
        self.until = nil
    }

    @inlinable
    public init(
        @ParseBuilder builder: () -> P,
        @ParseBuilder separator separatorBuilder: () -> Separator
    )
    where Until == NeverParser<Input> {
        self.parser = builder()
        self.separator = separatorBuilder()
        self.until = nil
    }

    @inlinable
    public init(
        @ParseBuilder builder: () -> P,
        @ParseBuilder until untilBuilder: () -> Until
    )
    where Separator == NeverParser<Input> {
        self.parser = builder()
        self.separator = nil
        self.until = untilBuilder()
    }

    @inlinable
    public init(
        @ParseBuilder builder: () -> P,
        @ParseBuilder separator separatorBuilder: () -> Separator,
        @ParseBuilder until untilBuilder: () -> Until
    ) {
        self.parser = builder()
        self.separator = separatorBuilder()
        self.until = untilBuilder()
    }

    @inlinable
    public func parse(_ input: P.Input) throws -> (output: [P.Output], remainder: P.Input)? {
        var results: [P.Output] = []
        var remaining = input
        
        var untilResult = try until?.parse(remaining)
        var separatorMatch = true
        
        while
            untilResult == nil,
            separatorMatch,
            let (result, newRemaining) = try parser.parse(remaining)
        {
            remaining = newRemaining
            results.append(result)
            
            if let separator {
                if let (_, separatorRemaining) = try separator.parse(remaining) {
                    remaining = separatorRemaining
                } else {
                    separatorMatch = false
                }
            }
            
            untilResult = try until?.parse(remaining)
        }

        if let untilResult {
            remaining = untilResult.1
        }
        
        return (results, remaining)
    }
}

extension ZeroOrMore: Sendable where P: Sendable, Separator: Sendable, Until: Sendable {}
