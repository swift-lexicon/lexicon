//
//  StringSyntax.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

// quotation-mark = %x22      ; "
@usableFromInline
internal let quotationMark = Character("\"").asParser

// escape = %x5C              ; \
@usableFromInline
internal let escape = Character("\\").asParser

// unescaped = %x20-21 / %x23-5B / %x5D-10FFFF
@usableFromInline
internal let unescapedRange = CharacterSet()
    .union(CharacterSet(charactersIn: UnicodeScalar(0x20)...UnicodeScalar(0x21)))
    .union(CharacterSet(charactersIn: UnicodeScalar(0x23)...UnicodeScalar(0x5B)))
    .union(CharacterSet(charactersIn: UnicodeScalar(0x5D)...UnicodeScalar(UInt32(0x10FFFF))!))

@inlinable
func isUnescaped(_ character: Character) -> Bool {
    guard let scalar = character.unicodeScalars.first else {
        return false
    }
    return unescapedRange.contains(scalar)
}

@usableFromInline
internal let unescaped = Spot<Substring>(isUnescaped)

/*
 char = unescaped /
     escape (
         %x22 /          ; "    quotation mark  U+0022
         %x5C /          ; \    reverse solidus U+005C
         %x2F /          ; /    solidus         U+002F
         %x62 /          ; b    backspace       U+0008
         %x66 /          ; f    form feed       U+000C
         %x6E /          ; n    line feed       U+000A
         %x72 /          ; r    carriage return U+000D
         %x74 /          ; t    tab             U+0009
         %x75 4HEXDIG )  ; uXXXX                U+XXXX
 */
@usableFromInline
internal let character = OneOf {
    unescaped
    Parse {
        escape
        escaped
    }.map(\.match)
}

@usableFromInline
internal let stringSyntax = Parse {
    quotationMark
    SkipWhile {
        character
    }.capture()
    quotationMark
}.map(\.captures)

@usableFromInline
internal let escapedCharacterSet = CharacterSet([
    UnicodeScalar(0x22),
    UnicodeScalar(0x5C),
    UnicodeScalar(0x2F),
    UnicodeScalar(0x62),
    UnicodeScalar(0x66),
    UnicodeScalar(0x6E),
    UnicodeScalar(0x72),
    UnicodeScalar(0x74)
])

@inlinable
internal func isEscapedCharacter(_ character: Character) -> Bool {
    guard let token = character.unicodeScalars.first else {
        return false
    }
    return escapedCharacterSet.contains(token)
}

@usableFromInline
internal let escapedHexRepresentation = Parse {
    Character("u")
    hexDigit.repeating(times: 4)
}.map(\.match)

@usableFromInline
internal let escaped = OneOf {
    Spot<Substring>(isEscapedCharacter)
    escapedHexRepresentation
}
