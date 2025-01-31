//
//  Values.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

struct JsonObject: Parser {
    // object = begin-object [ member *( value-separator member ) ] end-object
    // member = string name-separator value
    internal var member: some Parser<Substring, (Substring, JsonValue)> {
        Parse {
            stringSyntax.capture()
            nameSeparator.throwOnFailure(JsonParserError.objectMissingNameSeparator)
            JsonParser().capture()
        }.map { $0.captures }
    }
    
    internal var objectValue: some Parser<Substring, JsonValue> {
        Parse {
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
    }
    
    public func parse(_ input: Substring) throws -> ParseResult<JsonValue, Substring>? {
        try objectValue.parse(input)
    }
}

struct JsonArray: Parser {
    // array = begin-array [ value *( value-separator value ) ] end-array
    internal var arrayValue: some Parser<Substring, JsonValue> {
        Parse {
            beginArray
            
            ZeroOrMore {
                JsonParser().capture()
            } separator: {
                valueSeparator
            }
            .map({ $0.map(\.captures) })
            .capture()
            
            endArray.throwOnFailure(JsonParserError.arrayMissingClosingBracket)
        }.map({ JsonValue.array(value: $0.captures ) })
    }
    
    public func parse(_ input: Substring) throws -> ParseResult<JsonValue, Substring>? {
        try arrayValue.parse(input)
    }
}

public struct JsonParser: Parser {
    // value = false / null / true / object / array / number / string
    internal var jsonValueParser: some Parser<Substring, JsonValue> {
        Parse {
            ws
            OneOf {
                JsonArray()
                JsonObject()
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
    }
    
    // true  = %x74.72.75.65      ; true
    internal let trueLiteral = "true".asParser.map { _ in JsonValue.boolean(value: true) }

    // false = %x66.61.6c.73.65   ; false
    internal let falseLiteral = "false".asParser.map { _ in JsonValue.boolean(value: false) }

    // null  = %x6e.75.6c.6c      ; null
    internal let nullLiteral = "null".asParser.map { _ in JsonValue.null }

    // string = quotation-mark *char quotation-mark
    internal let stringValue = stringSyntax.map { JsonValue.string(value: String($0)) }

    // number = [ minus ] int [ frac ] [ exp ]
    internal let numberValue = number.map { JsonValue.number(value: Double($0)!) }
    
    public func parse(_ input: Substring) throws -> ParseResult<JsonValue, Substring>? {
        try jsonValueParser.parse(input)
    }
}

extension JsonParser: Sendable {}
