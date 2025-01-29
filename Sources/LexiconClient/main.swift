//
//  main.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon


let listOfNames = "alex,lottie,\"smith,steven\",ainslie,david"

print(listOfNames.split(separator: ","))
// Wrong result!
// ["alex", "lottie", "\"smith", "steven\"", "ainslie", "david"]

let quotedField = Parse {
    Character("\"")
    SkipWhile {
        Not { Character("\"") }
    }.capture()
    Character("\"")
}.map(\.captures)

let unquotedField = SkipWhile {
    Not {
        Character(",")
    }
}

let commaSeparatedParser = ZeroOrMore {
    OneOf {
        quotedField
        unquotedField
    }.capture()
} separator: {
    Character(",")
}.map { $0.map(\.captures) }

let names = try commaSeparatedParser.parse(listOfNames)

print(names as Any)
// Right result!
// Optional(["alex", "lottie", "smith,steven", "ainslie", "david"])
