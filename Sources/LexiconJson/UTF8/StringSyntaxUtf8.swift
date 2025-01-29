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
internal let quotationMarkUtf8 = Token<Substring.UTF8View.SubSequence>("\"".data(using: .utf8)!.first!)

// escape = %x5C              ; \
@usableFromInline
internal let escapeUtf8 = Token<Substring.UTF8View.SubSequence>("\\".data(using: .utf8)!.first!)

// unescaped = %x20-21 / %x23-5B / %x5D-10FFFF
@usableFromInline
internal let unescapedRangeUtf8 = Set<Substring.UTF8View.SubSequence.Element>()
    .union(0x20...0x21)
    .union(0x23...0x5B)
    .union(0x5D...0xFF)

@inlinable
func isUnescapedUtf8(_ character: Substring.UTF8View.SubSequence.Element) -> Bool {
    return unescapedRangeUtf8.contains(character)
}

@usableFromInline
internal let unescapedUtf8 = Spot<Substring.UTF8View.SubSequence>(isUnescapedUtf8)

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
internal let characterUtf8 = OneOf {
    unescapedUtf8
    Parse {
        escapeUtf8
        escapedUtf8
    }.map(\.match)
}

@usableFromInline
internal let stringSyntaxUtf8 = Parse {
    quotationMarkUtf8
    SkipWhile {
        characterUtf8
    }.capture()
    quotationMarkUtf8
}.map(\.captures)

@usableFromInline
internal let escapedCharacterSetUtf8 = Set<Substring.UTF8View.SubSequence.Element>([
    0x22, 0x5C, 0x2F, 0x62, 0x66, 0x6E, 0x72, 0x74
])
@inlinable
internal func isEscapedCharacterUtf8(_ character: Data.Element) -> Bool {
    return escapedCharacterSetUtf8.contains(character)
}

@usableFromInline
internal let hexCharacterRangeUtf8 = Set<Substring.UTF8View.SubSequence.Element>()
    .union(0x30...0x39)
    .union(0x41...0x5A)
    .union(0x61...0x7A)

@inlinable
internal func isHexCharacterUtf8(_ character: Substring.UTF8View.SubSequence.Element) -> Bool {
    return hexCharacterRangeUtf8.contains(character)
}
@usableFromInline
internal let escapedHexRepresentationUtf8 = Parse {
    Token<Substring.UTF8View.SubSequence>("u".utf8.first!)
    Spot<Substring.UTF8View.SubSequence>(isHexCharacterUtf8).repeating(times: 4)
}.map(\.match)

@usableFromInline
internal let escapedUtf8 = OneOf {
    Spot<Substring.UTF8View.SubSequence>(isEscapedCharacterUtf8)
    escapedHexRepresentationUtf8
}
