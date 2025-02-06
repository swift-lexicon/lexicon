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
internal let quotationMarkUtf8 = Token<Substring.UTF8View>("\"".utf8.first!)

// escape = %x5C              ; \
@usableFromInline
internal let escapeUtf8 = Token<Substring.UTF8View>("\\".utf8.first!)

// unescaped = %x20-21 / %x23-5B / %x5D-10FFFF
@usableFromInline
internal let unescapedRangeUtf8 = Set<UTF8.CodeUnit>()
    .union(0x20...0x21)
    .union(0x23...0x5B)
    .union(0x5D...0xFF)

@inlinable
func isUnescapedUtf8(_ character: UTF8.CodeUnit) -> Bool {
    return unescapedRangeUtf8.contains(character)
}

@usableFromInline
internal let unescapedUtf8 = Spot<Substring.UTF8View>(isUnescapedUtf8)

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
struct CharacterSyntaxUtf8: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        OneOf {
            unescapedUtf8
            Parse {
                escapeUtf8
                EscapedUtf8()
            }
        }
    }
}

@usableFromInline
struct StringSyntaxUtf8: ParserPrinter, Sendable {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            quotationMarkUtf8
            SkipWhile {
                CharacterSyntaxUtf8()
            }.capture()
            quotationMarkUtf8
        }
    }
}

@usableFromInline
internal let escapedCharacterSetUtf8 = Set<UTF8.CodeUnit>([
    0x22,
    0x5C,
    0x2F,
    0x62,
    0x66,
    0x6E,
    0x72,
    0x74
])

@inlinable
internal func isEscapedCharacterUtf8(_ character: UTF8.CodeUnit) -> Bool {
    return escapedCharacterSetUtf8.contains(character)
}

public let hexDigitUtf8 = Spot<Substring.UTF8View> {
    ($0 >= 30 && $0 <= 39) ||
    ($0 >= 65 && $0 <= 70) ||
    ($0 >= 97 && $0 <= 102)
}

@usableFromInline
struct EscapedHexRepresentationUtf8: ParserPrinter, Sendable {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            Token<Substring.UTF8View>("u".utf8.first!)
            hexDigitUtf8.repeating(times: 4)
        }
    }
}

@usableFromInline
struct EscapedUtf8: ParserPrinter, Sendable {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        OneOf {
            Spot<Substring.UTF8View>(isEscapedCharacterUtf8)
            EscapedHexRepresentationUtf8()
        }
    }
}
