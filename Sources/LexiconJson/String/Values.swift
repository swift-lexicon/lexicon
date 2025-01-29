//
//  Values.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

// value = false / null / true / object / array / number / string
@usableFromInline
internal let jsonValueParser = Parse {
    ws
    OneOf {
        Closure(parseArray)
        Closure(parseObject)
        nullLiteral
        trueLiteral
        falseLiteral
        numberValue
        stringValue
    }
    .throwOnFailure(JsonParserError.notAValidJsonValue)
    .capture()
    ws
}.map(\.captures)

// true  = %x74.72.75.65      ; true
@usableFromInline
internal let trueLiteral = "true".asParser.map { _ in JsonValue.boolean(value: true) }

// false = %x66.61.6c.73.65   ; false
@usableFromInline
internal let falseLiteral = "false".asParser.map { _ in JsonValue.boolean(value: false) }

// null  = %x6e.75.6c.6c      ; null
@usableFromInline
internal let nullLiteral = "null".asParser.map { _ in JsonValue.null }

// string = quotation-mark *char quotation-mark
@usableFromInline
internal let stringValue = stringSyntax.map { JsonValue.string(value: String($0)) }

// number = [ minus ] int [ frac ] [ exp ]
@usableFromInline
internal let numberValue = number.map { JsonValue.number(value: Double($0)!) }

// array = begin-array [ value *( value-separator value ) ] end-array
@usableFromInline
internal let arrayValue = Parse {
    beginArray
    
    ZeroOrMore {
        jsonValueParser.capture()
    } separator: {
        valueSeparator
    }
    .map({ $0.map(\.captures) })
    .capture()
    
    endArray.throwOnFailure(JsonParserError.arrayMissingClosingBracket)
}.map({ JsonValue.array(value: $0.captures ) })

@usableFromInline
internal func parseArray(_ input: Substring) throws -> ParseResult<JsonValue, Substring>? {
    try arrayValue.parse(input)
}

// member = string name-separator value
@usableFromInline
internal let member = Parse {
    stringSyntax.capture()
    nameSeparator.throwOnFailure(JsonParserError.objectMissingNameSeparator)
    jsonValueParser.capture()
}.map { ($0.captures.0, $0.captures.1) }

// object = begin-object [ member *( value-separator member ) ] end-object
@usableFromInline
internal let objectValue = Parse {
    beginObject
    
    ZeroOrMore {
        member.capture()
    } separator: {
        valueSeparator
    }
    .map({ $0.map { $0.captures } })
    .capture()
    
    endObject.throwOnFailure(JsonParserError.objectMissingClosingBrace)
}.map {
    var dictionary: [String: JsonValue] = [:]
    for (key, value) in $0.captures {
        dictionary[String(key)] = value
    }
    return JsonValue.object(value: dictionary)
}

@usableFromInline
internal func parseObject(_ input: Substring) throws -> ParseResult<JsonValue, Substring>? {
    try objectValue.parse(input)
}

