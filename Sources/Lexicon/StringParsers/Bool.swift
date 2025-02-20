//
//  Bool.swift
//  Lexicon
//
//  Created by Aaron Vranken on 28/01/2025.
//

/**
 # Description
 A `Substring` parser that matches "true" and "false" literals and maps them to Swift `Bool` values.
 */
public let bool = OneOf {
    Match("true").map { _ in true }
    Match("false").map { _ in false }
}

public extension StringParsers {
    static let bool = Lexicon.bool
}
