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
internal let quotationMarkUtf8 = "\"".utf8.first!.asParser

// escape = %x5C              ; \
@usableFromInline
internal let escapeUtf8 = "\\".utf8.first!.asParser

// unescaped = %x20-21 / %x23-5B / %x5D-10FFFF
@usableFromInline
internal let unescapedUtf8 = Spot<Substring.UTF8View> {
    ($0 >= 0x20 && $0 <= 0x21) ||
    ($0 >= 0x23 && $0 <= 0x5B) ||
    $0 >= 0x5D
}

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
            quotationMarkUtf8.throwOnFailure(JsonParserError.stringMissingClosingQuotationMark)
        }
    }
}

@usableFromInline
internal let hexDigitUtf8 = Spot<Substring.UTF8View> {
    ($0 >= 0x30 && $0 <= 0x39) ||
    ($0 >= 0x41 && $0 <= 0x5A) ||
    ($0 >= 0x61 && $0 <= 0x7A)
}

@usableFromInline
struct EscapedHexRepresentationUtf8: ParserPrinter, Sendable {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            "u".utf8.first!
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
            Spot<Substring.UTF8View> {
                $0 == 0x22 ||
                $0 == 0x5C ||
                $0 == 0x2F ||
                $0 == 0x62 ||
                $0 == 0x66 ||
                $0 == 0x6E ||
                $0 == 0x72 ||
                $0 == 0x74
            }
            EscapedHexRepresentationUtf8()
        }
    }
}
