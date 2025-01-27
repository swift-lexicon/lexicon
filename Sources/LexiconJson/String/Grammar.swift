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
    whitespace
    Capture { Character("[") }
    whitespace
}.transform(\.captures)

// end-array       = ws %x5D ws  ; ] right square bracket
@usableFromInline
internal let endArray = Parse {
    whitespace
    Capture { Character("]") }
    whitespace
}.transform(\.captures)

// begin-object    = ws %x7B ws  ; { left curly bracket
@usableFromInline
internal let beginObject = Parse {
    whitespace
    Capture { Character("{") }
    whitespace
}.transform(\.captures)

// end-object      = ws %x7D ws  ; } right curly bracket
@usableFromInline
internal let endObject = Parse {
    whitespace
    Capture { Character("}") }
    whitespace
}.transform(\.captures)

// name-separator  = ws %x3A ws  ; : colon
@usableFromInline
internal let nameSeparator = Parse {
    whitespace
    Capture { Character(":") }
    whitespace
}.transform(\.captures)

// value-separator = ws %x2C ws  ; , comma
@usableFromInline
internal let valueSeparator = Parse {
    whitespace
    Capture { Character(",") }
    whitespace
}.transform(\.captures)

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

@usableFromInline
internal let whitespace = While {
    Spot<Substring> { element in
        guard let token = element.unicodeScalars.first else {
            return false
        }
        return whitespaceCharacters.contains(token)
    }
}
