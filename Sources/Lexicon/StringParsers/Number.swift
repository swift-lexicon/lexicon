//
//  Number.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

public let matchNaturalNumber = Parse {
    nonZeroAsciiNumber
    ZeroOrMore {
        asciiNumber
    }
}.map(\.match)

public let matchNegativeNumber = Parse {
    Character("-")
    matchNaturalNumber
}.map(\.match)

public let matchInteger = OneOf {
    matchNaturalNumber
    matchNegativeNumber
}
