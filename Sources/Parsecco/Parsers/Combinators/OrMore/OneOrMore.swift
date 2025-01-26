//
//  OneOrMore.swift
//
//
//  Created by Aaron Vranken on 26/01/2025.
//

import Foundation

public struct OneOrMore<P: Parser, Separator: Parser, Until: Parser>: Parser
where P.Input == Separator.Input, P.Input == Until.Input {
    public let zeroOrMore: ZeroOrMore<P, Separator, Until>
    
    @inlinable public init(@ParserBuilder builder: () -> P)
    where
        Separator == NeverParser<P.Input>,
        Until == NeverParser<P.Input>
    {
        self.zeroOrMore = ZeroOrMore(builder: builder)
    }
    
    @inlinable public init(
        @ParserBuilder builder: () -> P,
        @ParserBuilder separator: () -> Separator
    ) where Until == NeverParser<P.Input> {
        self.zeroOrMore = ZeroOrMore(
            builder: builder,
            separator: separator
        )
    }
    
    @inlinable public init(
        @ParserBuilder builder: () -> P,
        @ParserBuilder until: () -> Until
    ) where Separator == NeverParser<P.Input> {
        self.zeroOrMore = ZeroOrMore(
            builder: builder,
            until: until
        )
    }
    
    @inlinable public init(
        @ParserBuilder builder: () -> P,
        @ParserBuilder separator: () -> Separator,
        @ParserBuilder until: () -> Until
    ) {
        self.zeroOrMore = ZeroOrMore(
            builder: builder,
            separator: separator,
            until: until
        )
    }

    @inlinable public func parse(
        _ input: P.Input
    ) throws -> (output: [P.Output], remainder: P.Input)? {
        guard
            let (result, remaining) = try zeroOrMore.parse(input),
            !result.isEmpty else {
            return nil
        }
        
        return (result, remaining)
    }
}

extension OneOrMore: Sendable where P: Sendable, Separator: Sendable, Until: Sendable {}
