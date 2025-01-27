//
//  Main.swift
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
    While {
        Not { Character("\"") }
    }.capture()
    Character("\"")
}.transform(\.captures)

let unquotedField = While {
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
}.transform { $0.map(\.captures) }

let names = try commaSeparatedParser.parse(listOfNames)

print(names)
// Right result!
// Optional(["alex", "lottie", "smith,steven", "ainslie", "david"])

let accented = Character("é")

print(accented.isASCII, accented.isLetter)
