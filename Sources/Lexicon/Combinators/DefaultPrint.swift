//
//  DefaultPrint.swift
//  lexicon
//
//  Created by Aaron Vranken on 03/02/2025.
//

import Foundation

public struct DefaultPrint<P: Parser>: Parser & VoidPrinter {
    @usableFromInline let parser: P
    @usableFromInline let printValue: P.Input
    
    @inlinable
    public init(
        _ parser: P,
        printValue: P.Input)
    {
        self.parser = parser
        self.printValue = printValue
    }
    
    @inlinable
    public func print() -> P.Input? {
        return printValue
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        try parser.parse(input)
    }
}

extension DefaultPrint: Sendable where P: Sendable, P.Input: Sendable {}

extension DefaultPrint: Printer where P: Printer {
    public func print(_ output: P.Output) throws -> P.Input? {
        try parser.print(output)
    }
}

public extension ParserConvertible {
    @inlinable
    func defaultPrint<I>(
        _ print: I
    ) -> DefaultPrint<ParserType>
    where I: Collection, ParserType.Input: Collection, ParserType.Input == I.SubSequence {
        DefaultPrint(
            self.asParser,
            printValue: print[...]
        )
    }
}

public extension Parsers {
    typealias DefaultPrint = Lexicon.DefaultPrint
}
