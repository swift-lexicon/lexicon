//
//  OneOrMore.swift
//
//
//  Created by Aaron Vranken on 26/01/2025.
//

public struct OneOrMore<RepeatParser: Parser>: Parser {
    @usableFromInline let parser: RepeatParser

    @inlinable
    public init<P: Parser>(@ParseBuilder builder: () -> P)
    where RepeatParser == Repeat<RepeatParsers.RepeatBasic<P>>{
        self.parser = Repeat(between: 1..., parser: builder())
    }

    @inlinable
    public init<P: Parser, Separator: Parser>(
        @ParseBuilder builder: () -> P,
        @DiscardBuilder separator: () -> Separator
    )
    where RepeatParser == Repeat<RepeatParsers.RepeatSeparator<P, Separator>> {
        self.parser = Repeat(
            between: 1...,
            parser: builder(),
            separator: separator()
        )
    }
    
    @inlinable
    public init<P: Parser, Until: Parser>(
        @ParseBuilder builder: () -> P,
        @DiscardBuilder until: () -> Until
    )
    where RepeatParser == Repeat<RepeatParsers.RepeatUntil<P, Until>> {
        self.parser = Repeat(
            between: 1...,
            parser: builder(),
            until: until()
        )
    }
    
    @inlinable
    public func parse(_ input: RepeatParser.Input) throws -> ParseResult<RepeatParser.Output, RepeatParser.Input>? {
        try parser.parse(input)
    }
}

extension OneOrMore: Sendable where RepeatParser: Sendable {}

extension OneOrMore: Printer where RepeatParser: Printer {
    @inlinable
    public func print(_ output: RepeatParser.Output) throws -> RepeatParser.Input? {
        try parser.print(output)
    }
}
