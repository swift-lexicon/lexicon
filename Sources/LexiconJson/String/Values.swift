//
//  Values.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

@usableFromInline
struct JsonObject: Parser {
    // member = string name-separator value
    @inlinable
    internal var member: some Parser<Substring, (Substring, JsonValue)> {
        Parse {
            stringSyntax.capture()
            nameSeparator.throwOnFailure(JsonParserError.objectMissingNameSeparator)
            JsonParser().capture()
        }.map { $0.captures }
    }
    
    // object = begin-object [ member *( value-separator member ) ] end-object
    @inlinable
    internal var body: some Parser<Substring, JsonValue> {
        Parse {
            beginObject
            
            ZeroOrMore {
                member.capture()
            } separator: {
                valueSeparator
            }
            .map({ $0.map(\.captures)})
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
    
    @inlinable
    init() {}
}

@usableFromInline
struct JsonArray: Parser {
    // array = begin-array [ value *( value-separator value ) ] end-array
    @inlinable
    internal var body: some Parser<Substring, JsonValue> {
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
    
    @inlinable
    init() {}
}

public struct JsonParser: Parser {
    // true  = %x74.72.75.65      ; true
    @usableFromInline
    internal let trueLiteral = "true".map { _ in JsonValue.boolean(value: true) }

    // false = %x66.61.6c.73.65   ; false
    @usableFromInline
    internal let falseLiteral = "false".map { _ in JsonValue.boolean(value: false) }

    // null  = %x6e.75.6c.6c      ; null
    @usableFromInline
    internal let nullLiteral = "null".map { _ in JsonValue.null }

    // string = quotation-mark *char quotation-mark
    @usableFromInline
    internal let stringValue = stringSyntax.map { JsonValue.string(value: String($0)) }

    // number = [ minus ] int [ frac ] [ exp ]
    @usableFromInline
    internal let numberValue = number.map { JsonValue.number(value: Double($0)!) }
    
    @inlinable
    public var body: some Parser<Substring, JsonValue> {
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
        }.map { $0.captures }
    }
    
    @inlinable
    init() {}
}

extension JsonParser: Sendable {}
