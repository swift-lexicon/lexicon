//
//  OneOfBuilder.swift
//  Lexicon
//
//  Created by Aaron Vranken on 26/01/2025.
//

@attached(member, names: arbitrary)
public macro generateOneOfBuilderMembers(_ value: Int) = #externalMacro(module: "LexiconMacros", type: "GenerateOneOfBuilderMembers")

@resultBuilder
public enum OneOfBuilder {}

// Define simple 1-arity case
public extension OneOfBuilder {
    @inlinable
    static func buildBlock<P: ParserConvertible>(_ parser: P) -> P.ParserType {
        return parser.asParser
    }
}

// Automatically generate variadic cases
@generateOneOfBuilderMembers(10)
public extension OneOfBuilder { }
