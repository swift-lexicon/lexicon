////
////  Values.swift
////  Lexicon
////
////  Created by Aaron Vranken on 27/01/2025.
////
//
//import Foundation
//import Lexicon
//
//// true  = %x74.72.75.65      ; true
//@usableFromInline
//internal let trueLiteralUtf8 = Match("true".utf8).map {
//    _ in JsonValue.boolean(value: true)
//}
//
//// false = %x66.61.6c.73.65   ; false
//@usableFromInline
//internal let falseLiteralUtf8 = Match("false".utf8).map {
//    _ in JsonValue.boolean(value: false)
//}
//
//// null  = %x6e.75.6c.6c      ; null
//@usableFromInline
//internal let nullLiteralUtf8 = Match("null".utf8).map {
//    _ in JsonValue.null
//}
//
//// string = quotation-mark *char quotation-mark
//@usableFromInline
//internal let stringValueUtf8 = stringSyntaxUtf8.map {
//    JsonValue.string(value: String($0)!)
//}
//
//// number = [ minus ] int [ frac ] [ exp ]
//@usableFromInline
//internal let numberValueUtf8 = numberUtf8.map {
//    JsonValue.number(value: Double(String($0)!)!)
//}
//
//// array = begin-array [ value *( value-separator value ) ] end-array
//@usableFromInline
//internal let arrayValueUtf8 = Parse {
//    beginArrayUtf8
//    
//    ZeroOrMore {
//        jsonParserUtf8.capture()
//    } separator: {
//        valueSeparatorUtf8
//    }
//    .map({ $0.map(\.captures) })
//    .capture()
//    
//    endArrayUtf8.throwOnFailure(JsonParserError.arrayMissingClosingBracket)
//}.map({ JsonValue.array(value: $0.captures ) })
//
//@usableFromInline
//internal func parseArrayUtf8(_ input: Substring.UTF8View.SubSequence) throws -> ParseResult<JsonValue, Substring.UTF8View.SubSequence>? {
//    try arrayValueUtf8.parse(input)
//}
//
//// member = string name-separator value
//@usableFromInline
//internal let memberUtf8 = Parse {
//    stringSyntaxUtf8.capture()
//    nameSeparatorUtf8.throwOnFailure(JsonParserError.objectMissingNameSeparator)
//    jsonParserUtf8.capture()
//}.map { ($0.captures.0, $0.captures.1) }
//
//// object = begin-object [ member *( value-separator member ) ] end-object
//@usableFromInline
//internal let objectValueUtf8 = Parse {
//    beginObjectUtf8
//    
//    ZeroOrMore {
//        memberUtf8.capture()
//    } separator: {
//        valueSeparatorUtf8
//    }
//    .map({ $0.map { $0.captures } })
//    .capture()
//    
//    endObjectUtf8.throwOnFailure(JsonParserError.objectMissingClosingBrace)
//}.map {
//    var dictionary: [String: JsonValue] = [:]
//    for (key, value) in $0.captures {
//        dictionary[String(key)!] = value
//    }
//    return JsonValue.object(value: dictionary)
//}
//
//@usableFromInline
//internal func parseObjectUtf8(_ input: Substring.UTF8View.SubSequence) throws -> ParseResult<JsonValue, Substring.UTF8View.SubSequence>? {
//    try objectValueUtf8.parse(input)
//}
//
