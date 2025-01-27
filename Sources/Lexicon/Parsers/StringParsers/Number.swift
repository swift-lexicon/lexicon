//
//  Number.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

public let matchNaturalNumber = Parse {
    OneOrMore {
        asciiNumber
    }
}.transform(\.match)

public let matchNegativeNumber = Parse {
    Character("-")
    matchNaturalNumber
}.transform(\.match)

public let matchInteger = OneOf {
    matchNaturalNumber
    matchNegativeNumber
}
