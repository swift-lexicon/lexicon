//
//  NeverParser.swift
//  lexicon
//
//  Created by Aaron Vranken on 07/02/2025.
//

import Foundation

public struct NeverParser<Input, Output>: Parser, VoidPrinter, Printer, ParserPrinter, Sendable {
    @inlinable
    public func parse(_ input: Input) throws -> ParseResult<Output, Input>? {
        fatalError(
            """
            NeverParser.parse was called which should never occur!
            """
        )
    }
    
    @inlinable
    public func print() throws -> Input? {
        fatalError(
            """
            NeverParser.print (void) was called which should never occur!
            """
        )
    }
    
    @inlinable
    public func print(_ output: Output) throws -> Input? {
        fatalError(
            """
            NeverParser.print was called which should never occur!
            """
        )
    }
}
