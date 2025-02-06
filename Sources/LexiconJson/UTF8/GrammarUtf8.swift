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
    Token<String.UTF8View.SubSequence>("[".utf8.first!)
    whitespaceUtf8
}.defaultPrint("[ ".utf8)

// end-array       = ws %x5D ws  ; ] right square bracket
@usableFromInline
internal let endArrayUtf8 = Parse {
    whitespaceUtf8
    Token<Substring.UTF8View.SubSequence>("]".utf8.first!)
    whitespaceUtf8
}.defaultPrint("] ".utf8)

// begin-object    = ws %x7B ws  ; { left curly bracket
@usableFromInline
internal let beginObjectUtf8 = Parse {
    whitespaceUtf8
    Token<Substring.UTF8View.SubSequence>("{".utf8.first!)
    whitespaceUtf8
}.defaultPrint("{ ".utf8)

// end-object      = ws %x7D ws  ; } right curly bracket
@usableFromInline
internal let endObjectUtf8 = Parse {
    whitespaceUtf8
    Token<Substring.UTF8View.SubSequence>("}".utf8.first!)
    whitespaceUtf8
}.defaultPrint(" }".utf8)

// name-separator  = ws %x3A ws  ; : colon
@usableFromInline
internal let nameSeparatorUtf8 = Parse {
    whitespaceUtf8
    Token<Substring.UTF8View.SubSequence>(":".utf8.first!)
    whitespaceUtf8
}.defaultPrint(": ".utf8)

// value-separator = ws %x2C ws  ; , comma
@usableFromInline
internal let valueSeparatorUtf8 = Parse {
    whitespaceUtf8
    Token<Substring.UTF8View.SubSequence>(",".utf8.first!)
    whitespaceUtf8
}.defaultPrint(" )".utf8)

/*
 ws = *(
         %x20 /              ; Space
         %x09 /              ; Horizontal tab
         %x0A /              ; Line feed or New line
         %x0D )              ; Carriage return
 */

@inlinable
internal func isWhitespaceUtf8(_ token: Substring.UTF8View.SubSequence.Element) -> Bool {
    return token == 0x20 || token == 0x09 || token == 0x0A || token == 0x0D
}
@usableFromInline
internal let whitespaceUtf8 = SkipWhile {
    Spot<Substring.UTF8View.SubSequence>(isWhitespaceUtf8)
}
