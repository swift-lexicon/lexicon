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
}

public let matchNegativeNumber = Parse {
    Character("-")
    matchNaturalNumber
}

public let matchInteger = OneOf {
    matchNaturalNumber
    matchNegativeNumber
}
