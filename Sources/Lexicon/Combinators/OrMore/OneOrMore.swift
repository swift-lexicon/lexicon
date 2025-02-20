//
//  OneOrMore.swift
//
//
//  Created by Aaron Vranken on 26/01/2025.
//

/**
 # Description
 The `OneOrMore` parser returns one or more matches of the parser body.
 */
public struct OneOrMore<RepeatParser: Parser>: Parser {
    @usableFromInline let parser: RepeatParser

    @inlinable
    public init<P: Parser>(@ParseBuilder builder: () -> P)
    where RepeatParser == Repeat<
        P,
        NeverParser<P.Input, Void>,
        NeverParser<P.Input, Void>
    > {
        self.parser = Repeat(
            min: 1,
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
            min: 1,
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
            min: 1,
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

public extension Parsers {
    typealias OneOrMore = Lexicon.OneOrMore
}
