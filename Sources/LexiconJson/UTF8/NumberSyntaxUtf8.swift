//
//  NumberSyntax.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

extension Substring.UTF8View: Appendable & EmptyInitializable {
    @inlinable
    public static func initEmpty() -> Substring.UTF8View {
        return Substring().utf8
    }
    
    public mutating func append(_ newElement: String.UTF8View.Element) {
        self = (Substring(self) + String(newElement)).utf8
    }
    
    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, String.UTF8View.Element == S.Element {
        self = (Substring(self) + String(decoding: newElements.map { $0 }, as: UTF8.self)).utf8
    }
}

// number = [ minus ] int [ frac ] [ exp ]
@usableFromInline
struct NumberUtf8: ParserPrinter, Sendable {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            minusUtf8.optional()
            IntegerUtf8()
            FracUtf8().optional()
            ExpUtf8().optional()
        }
    }
}

// decimal-point = %x2E       ; .
@usableFromInline
internal let decimalPointUtf8 = Token<Substring.UTF8View>(".".utf8.first!)

// digit1-9 = %x31-39         ; 1-9
@usableFromInline
internal let digits1To9SetUtf8 = Set<UTF8.CodeUnit>(0x31...0x39)

@usableFromInline
internal let digit1To9Utf8 = Spot<Substring.UTF8View> {
    return digits1To9SetUtf8.contains($0)
}

@usableFromInline
internal let numberUtf8 = Spot<Substring.UTF8View> {
    $0 >= 0x30 && $0 <= 0x39
}

// e = %x65 / %x45            ; e E
@usableFromInline
internal let eUtf8 = OneOf {
    Token<Substring.UTF8View>("e".utf8.first!)
    Token<Substring.UTF8View>("E".utf8.first!)
}

// exp = e [ minus / plus ] 1*DIGIT
@usableFromInline
struct ExpUtf8: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            eUtf8
            Try {
                OneOf {
                    minusUtf8
                    plusUtf8
                }
            }
            OneOrMore {
                numberUtf8
            }.throwOnFailure(JsonParserError.exponentialMissingDigits)
        }
    }
}

// frac = decimal-point 1*DIGIT
@usableFromInline
struct FracUtf8: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            decimalPointUtf8
            OneOrMore {
                numberUtf8
            }.throwOnFailure(JsonParserError.fractionMissingDigits)
        }
    }
}

// int = zero / ( digit1-9 *DIGIT )
@usableFromInline
struct IntegerUtf8: ParserPrinter {
    @inlinable init() {}
    
    @inlinable
    var body: some ParserPrinter<Substring.UTF8View, Substring.UTF8View> {
        OneOf {
            zeroUtf8
            Parse {
                digit1To9Utf8
                ZeroOrMore {
                    numberUtf8
                }
            }
        }
    }
}

// minus = %x2D               ; -
@usableFromInline
internal let minusUtf8 = Token<Substring.UTF8View>("-".utf8.first!)

// plus = %x2B                ; +
@usableFromInline
internal let plusUtf8 = Token<Substring.UTF8View>("+".utf8.first!)

// zero = %x30                ; 0
@usableFromInline
internal let zeroUtf8 = Token<Substring.UTF8View>("0".utf8.first!)
