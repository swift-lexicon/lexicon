//
//  ZeroOrMore.swift
//
//
//  Created by Aaron Vranken on 26/01/2025.
//

/**
 # Description
 The `ZeroOrMore` parser returns zero or more matches of the parser body.
 */
public struct ZeroOrMore<RepeatParser: Parser>: Parser {
    @usableFromInline let parser: RepeatParser

    @inlinable
    public init<P: Parser>(@ParseBuilder builder: () -> P)
    where RepeatParser == Repeat<
        P,
        NeverParser<P.Input, Void>,
        NeverParser<P.Input, Void>
    > {
        self.parser = Repeat(
            parser: builder()
        )
    }

    @inlinable
    public init<P: Parser, Separator: Parser>(
        @ParseBuilder builder: () -> P,
        @DiscardBuilder separator: () -> Separator
    )
    where RepeatParser == Repeat<
        P,
        Separator,
        NeverParser<P.Input, Void>
    > {
        self.parser = Repeat(
            parser: builder(),
            separator: separator()
        )
    }
    
    @inlinable
    public init<P: Parser, Until: Parser>(
        @ParseBuilder builder: () -> P,
        @DiscardBuilder until: () -> Until
    )
    where RepeatParser == Repeat<
        P,
        NeverParser<P.Input, Void>,
        Until
    > {
        self.parser = Repeat(
            parser: builder(),
            until: until()
        )
    }
    
    @inlinable
    public func parse(_ input: RepeatParser.Input) throws -> ParseResult<RepeatParser.Output, RepeatParser.Input>? {
        try parser.parse(input)
    }
}

extension ZeroOrMore: Sendable where RepeatParser: Sendable {}

extension ZeroOrMore: Printer where RepeatParser: Printer {
    @inlinable
    public func print(_ output: RepeatParser.Output) throws -> RepeatParser.Input? {
        try parser.print(output)
    }
}

public extension Parsers {
    typealias ZeroOrMore = Lexicon.ZeroOrMore
}
