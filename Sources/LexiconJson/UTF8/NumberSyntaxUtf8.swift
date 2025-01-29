//
//  NumberSyntax.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

// number = [ minus ] int [ frac ] [ exp ]
@usableFromInline
internal let numberUtf8 = Parse {
    minusUtf8.optional()
    intUtf8
    fracUtf8.optional()
    expUtf8.optional()
}.map(\.match)

// decimal-point = %x2E       ; .
@usableFromInline
internal let decimalPointUtf8 = Token<Substring.UTF8View.SubSequence>(".".utf8.first!)

// digit1-9 = %x31-39         ; 1-9
@usableFromInline
internal let digits1To9SetUtf8 = Set<Substring.UTF8View.SubSequence.Element>()
    .union(0x31...0x39)

@usableFromInline
internal let digit1To9Utf8 = Spot<Substring.UTF8View.SubSequence> {
    return digits1To9SetUtf8.contains($0)
}

// e = %x65 / %x45            ; e E
@usableFromInline
internal let eUtf8 = OneOf {
    Token<Substring.UTF8View.SubSequence>("e".utf8.first!)
    Token<Substring.UTF8View.SubSequence>("E".utf8.first!)
}

// exp = e [ minus / plus ] 1*DIGIT
@usableFromInline
internal let expUtf8 = Parse {
    eUtf8
    Try {
        OneOf {
            minusUtf8
            plusUtf8
        }
    }
    OneOrMore {
        arabicNumeralUtf8
    }.throwOnFailure(JsonParserError.exponentialMissingDigits)
}

// frac = decimal-point 1*DIGIT
@usableFromInline
internal let fracUtf8 = Parse {
    decimalPointUtf8
    OneOrMore {
        arabicNumeralUtf8
    }.throwOnFailure(JsonParserError.fractionMissingDigits)
}

let utf8 = "abpij".utf8
@usableFromInline
internal let arabicNumeralsUtf8 = Set<Substring.UTF8View.SubSequence.Element>()
    .union(0x30...0x39)

@inlinable
internal func isArabicNumeralUtf8(_ character: Substring.UTF8View.SubSequence.Element) -> Bool {
    return arabicNumeralsUtf8.contains(character)
}

@usableFromInline
internal let arabicNumeralUtf8 = Spot<Substring.UTF8View.SubSequence>(isArabicNumeralUtf8)

// int = zero / ( digit1-9 *DIGIT )
@usableFromInline
internal let intUtf8 = OneOf {
    zeroUtf8
    Parse {
        digit1To9Utf8
        ZeroOrMore {
            arabicNumeralUtf8
        }
    }.map(\.match)
}

// minus = %x2D               ; -
@usableFromInline
internal let minusUtf8 = Token<Substring.UTF8View.SubSequence>("-".utf8.first!).asParser

// plus = %x2B                ; +
@usableFromInline
internal let plusUtf8 = Token<Substring.UTF8View.SubSequence>("+".utf8.first!).asParser

// zero = %x30                ; 0
@usableFromInline
internal let zeroUtf8 = Token<Substring.UTF8View.SubSequence>("0".utf8.first!).asParser
