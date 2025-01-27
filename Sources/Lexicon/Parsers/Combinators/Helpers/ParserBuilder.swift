//
//  CaptureBuilder.swift
//  
//
//  Created by Aaron Vranken on 24/01/2025.
//

import Foundation

@attached(member, names: arbitrary)
macro generateParserBuilderMembers(_ value: Int) = #externalMacro(module: "LexiconMacros", type: "GenerateParserBuilderMembers")

@resultBuilder
public enum ParserBuilder {}

// Singleton case
public extension ParserBuilder {
    @inlinable static func buildBlock<Parser1: ParserConvertible>(_ parser1: Parser1) -> Parser1.ParserType {
        parser1.asParser
    }
}

// Automatically generated variadic cases
@generateParserBuilderMembers(10)
public extension ParserBuilder {
}
