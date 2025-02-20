//
//  Number.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

@usableFromInline
internal let matchNonZeroNaturalNumber = Parse {
    nonZeroAsciiNumber
    ZeroOrMore {
        asciiNumber
    }
}

/**
 # Description
 A `Substring` parser that matches natural (non-negative whole) numbers.
 */
public let matchNaturalNumber = OneOf {
    Character("0")
    matchNonZeroNaturalNumber
}.map { Int(String($0))! }

public extension StringParsers {
    static let matchNaturalNumber = Lexicon.matchNaturalNumber
}

/**
 # Description
 A `Substring` parser that matches negative whole numbers.
 */
public let matchNegativeNumber = Parse {
    Character("-")
    matchNonZeroNaturalNumber
}.map { Int(String($0))! }

public extension StringParsers {
    static let matchNegativeNumber = Lexicon.matchNegativeNumber
}

/**
 # Description
 A `Substring` parser that matches all integer numbers.
 */
public let matchInteger = OneOf {
    matchNaturalNumber
    matchNegativeNumber
}

public extension StringParsers {
    static let matchInteger = Lexicon.matchInteger
}
