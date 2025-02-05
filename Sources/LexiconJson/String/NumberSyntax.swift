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
struct Number: ParserPrinter, Sendable {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring, Substring> {
        Parse {
            minus.optional()
            Integer()
            Frac().optional()
            Exp().optional()
        }
    }
}

// decimal-point = %x2E       ; .
@usableFromInline
internal let decimalPoint = Character(".").asParser

// digit1-9 = %x31-39         ; 1-9
@usableFromInline
internal let digits1To9Set = CharacterSet(
    charactersIn: UnicodeScalar(0x31)...UnicodeScalar(0x39)
)

@usableFromInline
internal let digit1To9 = Spot<Substring> {
    guard let token = $0.unicodeScalars.first else { return false }
    return digits1To9Set.contains(token)
}

// e = %x65 / %x45            ; e E
@usableFromInline
internal let e = OneOf {
    Character("e")
    Character("E")
}

// exp = e [ minus / plus ] 1*DIGIT
@usableFromInline
struct Exp: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring, Substring> {
        Parse {
            e
            Try {
                OneOf {
                    minus
                    plus
                }
            }
            OneOrMore {
                asciiNumber
            }.throwOnFailure(JsonParserError.exponentialMissingDigits)
        }
    }
}

// frac = decimal-point 1*DIGIT
@usableFromInline
struct Frac: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring, Substring> {
        Parse {
            decimalPoint
            OneOrMore {
                asciiNumber
            }.throwOnFailure(JsonParserError.fractionMissingDigits)
        }
    }
}

// int = zero / ( digit1-9 *DIGIT )
@usableFromInline
struct Integer: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring, Substring> {
        OneOf {
            zero
            Parse {
                digit1To9
                ZeroOrMore {
                    asciiNumber
                }
            }
        }
    }
}

// minus = %x2D               ; -
@usableFromInline
internal let minus = Character("-").asParser

// plus = %x2B                ; +
@usableFromInline
internal let plus = Character("+").asParser

// zero = %x30                ; 0
@usableFromInline
internal let zero = Character("0").asParser
