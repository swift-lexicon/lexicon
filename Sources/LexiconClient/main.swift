//
//  main.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon


let listOfNames = "alex,lottie,\"smith,steven\",ainslie,david"

// Wrong result!
// ["alex", "lottie", "\"smith", "steven\"", "ainslie", "david"]
print(listOfNames.split(separator: ","))

let quotedField = Parse {
    Character("\"")
    SkipWhile {
        Not { Character("\"") }
    }.capture()
    Character("\"")
}

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
}

let names = try commaSeparatedParser.parse(listOfNames)

// Right result!
// Optional(["alex", "lottie", "smith,steven", "ainslie", "david"])
print(names?.output as Any)


let backToCSV = try commaSeparatedParser.print(names!.output)
print(backToCSV as Any)
// Optional("\"alex\",\"lottie\",\"smith,steven\",\"ainslie\",\"david\"")
