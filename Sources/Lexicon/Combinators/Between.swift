//
//  Between.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

public struct Between<Begin: Parser, End: Parser>: Parser
where Begin.Input: Collection, Begin.Input == Begin.Input.SubSequence, Begin.Input == End.Input {
    @usableFromInline
    internal let begin: Begin
    @usableFromInline
    internal let untilEnd: Until<End>
    
    @inlinable
    public init<B: ParserConvertible, E: ParserConvertible>(
        _ begin: B,
        and end: E
    ) where Begin == B.ParserType, End == E.ParserType {
        self.begin = begin.asParser
        self.untilEnd = Until(end.asParser)
    }
    
    @inlinable
    public init(
        @DiscardBuilder begin: () -> Begin,
        @DiscardBuilder and end: () -> End
    ) {
        self.begin = begin()
        self.untilEnd = Until(end())
    }
    
    @inlinable
    public func parse(_ input: Begin.Input) throws -> ParseResult<Begin.Input, Begin.Input>? {
        if let result = try begin.parse(input) {
            return try untilEnd.parse(result.remaining)
        }
        return nil
    }
}

extension Between: Sendable where Begin: Sendable, End: Sendable {}

extension Between: Printer
where Begin: VoidPrinter, End: VoidPrinter, Begin.Input: Appendable {
    @inlinable
    public func print(_ output: Begin.Input) throws -> Begin.Input? {
        guard let inputBegin = try begin.print(),
              let inputUntil = try untilEnd.print(output) else {
            return nil
        }
        
        var input = inputBegin
        input.append(contentsOf: inputUntil)
        
        return input
    }
}
