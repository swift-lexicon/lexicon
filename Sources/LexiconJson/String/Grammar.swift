//
//  Grammar.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

// begin-array     = ws %x5B ws  ; [ left square bracket
@usableFromInline
internal let beginArray = Parse {
    ws
    Character("[")
    ws
}.defaultPrint("[ ")

// end-array       = ws %x5D ws  ; ] right square bracket
@usableFromInline
internal let endArray = Parse {
    ws
    Character("]")
    ws
}.defaultPrint(" ]")

// begin-object    = ws %x7B ws  ; { left curly bracket
@usableFromInline
internal let beginObject = Parse {
    ws
    Character("{")
    ws
}.defaultPrint("{ ")

// end-object      = ws %x7D ws  ; } right curly bracket
@usableFromInline
internal let endObject = Parse {
    ws
    Character("}")
    ws
}.defaultPrint(" }")

// name-separator  = ws %x3A ws  ; : colon
@usableFromInline
internal let nameSeparator = Parse {
    ws
    Character(":")
    ws
}.defaultPrint(": ")

// value-separator = ws %x2C ws  ; , comma
@usableFromInline
internal let valueSeparator = Parse {
    ws
    Character(",")
    ws
}.defaultPrint(", ")

/*
 ws = *(
         %x20 /              ; Space
         %x09 /              ; Horizontal tab
         %x0A /              ; Line feed or New line
         %x0D )              ; Carriage return
 */
@usableFromInline
internal let whitespaceCharacters = CharacterSet([
    Unicode.Scalar(0x20),
    Unicode.Scalar(0x09),
    Unicode.Scalar(0x0A),
    Unicode.Scalar(0x0D)
])

@inlinable
internal func isWhitespace(_ character: Character) -> Bool {
    guard let token = character.utf8.first else {
        return false
    }
    
    return token == 0x20 || token == 0x09 || token == 0x0A || token == 0x0D
}

@usableFromInline
internal let ws = SkipWhile {
    Spot<Substring>(isWhitespace)
}
