//
//  CaptureBuilder.swift
//  
//
//  Created by Aaron Vranken on 24/01/2025.
//

@attached(member, names: arbitrary)
public macro generateParserBuilderMembers(_ value: Int) = #externalMacro(module: "LexiconMacros", type: "GenerateParserBuilderMembers")

@resultBuilder
public enum ParserBuilder {}

// Automatically generated variadic cases
@generateParserBuilderMembers(10)
public extension ParserBuilder {
}
