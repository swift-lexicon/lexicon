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
internal let beginArrayUtf8 = Parse {
    whitespaceUtf8
    Capture { Token<Data>("[".utf8.first!) }
    whitespaceUtf8
}.transform(\.captures)

// end-array       = ws %x5D ws  ; ] right square bracket
@usableFromInline
internal let endArrayUtf8 = Parse {
    whitespaceUtf8
    Capture { Token<Data>("]".utf8.first!) }
    whitespaceUtf8
}.transform(\.captures)

// begin-object    = ws %x7B ws  ; { left curly bracket
@usableFromInline
internal let beginObjectUtf8 = Parse {
    whitespaceUtf8
    Capture { Token<Data>("{".utf8.first!) }
    whitespaceUtf8
}.transform(\.captures)

// end-object      = ws %x7D ws  ; } right curly bracket
@usableFromInline
internal let endObjectUtf8 = Parse {
    whitespaceUtf8
    Capture { Token<Data>("}".utf8.first!) }
    whitespaceUtf8
}.transform(\.captures)

// name-separator  = ws %x3A ws  ; : colon
@usableFromInline
internal let nameSeparatorUtf8 = Parse {
    whitespaceUtf8
    Capture { Token<Data>(":".utf8.first!) }
    whitespaceUtf8
}.transform(\.captures)

// value-separator = ws %x2C ws  ; , comma
@usableFromInline
internal let valueSeparatorUtf8 = Parse {
    whitespaceUtf8
    Capture { Token<Data>(",".utf8.first!) }
    whitespaceUtf8
}.transform(\.captures)

/*
 ws = *(
         %x20 /              ; Space
         %x09 /              ; Horizontal tab
         %x0A /              ; Line feed or New line
         %x0D )              ; Carriage return
 */
@usableFromInline
internal let whitespaceCharactersUtf8 = Set<Data.Element>([
    0x20, 0x09, 0x0A, 0x0D
])

@inlinable
public func isWhitespaceUtf8(_ character: Data.Element) throws -> Bool {
    return whitespaceCharactersUtf8.contains(character)
}
@usableFromInline
internal let whitespaceUtf8 = While {
    Spot<Data>(isWhitespaceUtf8)
}
