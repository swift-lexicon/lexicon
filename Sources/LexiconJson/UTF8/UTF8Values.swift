//
//  Values.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

// true  = %x74.72.75.65      ; true
@usableFromInline
internal let trueLiteralUtf8 = Match("true".data(using: .utf8)!).transform {
    _ in JsonValue.boolean(value: true)
}

// false = %x66.61.6c.73.65   ; false
@usableFromInline
internal let falseLiteralUtf8 = Match("false".data(using: .utf8)!).transform {
    _ in JsonValue.boolean(value: false)
}

// null  = %x6e.75.6c.6c      ; null
@usableFromInline
internal let nullLiteralUtf8 = Match("null".data(using: .utf8)!).transform {
    _ in JsonValue.null
}

// string = quotation-mark *char quotation-mark
@usableFromInline
internal let stringValueUtf8 = stringSyntaxUtf8.transform {
    JsonValue.string(value: String(data: $0, encoding: .utf8)!)
}

// number = [ minus ] int [ frac ] [ exp ]
@usableFromInline
internal let numberValueUtf8 = numberUtf8.transform {
    JsonValue.number(value: Double(String(data: $0, encoding: .utf8)!)!)
}

// array = begin-array [ value *( value-separator value ) ] end-array
@usableFromInline
internal let arrayValueUtf8 = Parse {
    beginArrayUtf8
    
    ZeroOrMore {
        jsonParserUtf8.capture()
    } separator: {
        valueSeparatorUtf8
    }
    .transform({ $0.map(\.captures) })
    .capture()
    
    endArrayUtf8.throwOnFailure(JsonParserError.arrayMissingClosingBracket)
}.transform({ JsonValue.array(value: $0.captures ) })

@usableFromInline
internal func parseArrayUtf8(_ input: Data) throws -> ParseResult<JsonValue, Data>? {
    try arrayValueUtf8.parse(input)
}

// member = string name-separator value
@usableFromInline
internal let memberUtf8 = Parse {
    stringSyntaxUtf8.capture()
    nameSeparatorUtf8.throwOnFailure(JsonParserError.objectMissingNameSeparator)
    jsonParserUtf8.capture()
}.transform { ($0.captures.0, $0.captures.1) }

// object = begin-object [ member *( value-separator member ) ] end-object
@usableFromInline
internal let objectValueUtf8 = Parse {
    beginObjectUtf8
    
    ZeroOrMore {
        memberUtf8.capture()
    } separator: {
        valueSeparatorUtf8
    }
    .transform({ $0.map { $0.captures } })
    .capture()
    
    endObjectUtf8.throwOnFailure(JsonParserError.objectMissingClosingBrace)
}.transform {
    var dictionary: [String: JsonValue] = [:]
    for (key, value) in $0.captures {
        dictionary[String(data: key, encoding: .utf8)!] = value
    }
    return JsonValue.object(value: dictionary)
}

@usableFromInline
internal func parseObjectUtf8(_ input: Data) throws -> ParseResult<JsonValue, Data>? {
    try objectValueUtf8.parse(input)
}

