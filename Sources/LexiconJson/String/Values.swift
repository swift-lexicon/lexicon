//
//  Values.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

@usableFromInline
struct JsonObject: ParserPrinter {
    // member = string name-separator value
    @inlinable
    internal var member: some ParserPrinter<Substring, (Substring, JsonValue)> {
        Parse {
            StringSyntax().capture()
            nameSeparator.throwOnFailure(JsonParserError.objectMissingNameSeparator)
            JsonParser().capture()
        }
    }
    
    // object = begin-object [ member *( value-separator member ) ] end-object
    @inlinable
    internal var body: some ParserPrinter<Substring, JsonValue> {
        Parse {
            beginObject
            
            ZeroOrMore {
                member.capture()
            } separator: {
                valueSeparator
            }
            .capture()
            
            endObject.throwOnFailure(JsonParserError.objectMissingClosingBrace)
        }.map {
            var dictionary: [String: JsonValue] = [:]
            for (key, value) in $0 {
                dictionary[String(key)] = value
            }
            return JsonValue.object(value: dictionary)
        } invert: {
            guard case .object(let value) = $0 else {
                return nil
            }
            
            return value.map { ($0[...], $1) }
        }
    }
    
    @inlinable
    init() {}
}

@usableFromInline
struct JsonArray: ParserPrinter {
    // array = begin-array [ value *( value-separator value ) ] end-array
    @inlinable
    internal var body: some ParserPrinter<Substring, JsonValue> {
        Parse {
            beginArray
            
            ZeroOrMore {
                JsonParser().capture()
            } separator: {
                valueSeparator
            }
            .capture()
            
            endArray.throwOnFailure(JsonParserError.arrayMissingClosingBracket)
        }.map {
            JsonValue.array(value: $0 )
        } invert: { jsonValue in
            guard case .array(let value) = jsonValue else {
                return nil
            }
            
            return value
        }
    }
    
    @inlinable
    init() {}
}

public struct JsonParser: ParserPrinter {
    // true  = %x74.72.75.65      ; true
    @usableFromInline
    internal let trueLiteral = "true".map {
        _ in JsonValue.boolean(value: true)
    } invert: { jsonValue in
        guard case .boolean(let value) = jsonValue else {
            return nil
        }
        
        return "\(value)"
    }

    // false = %x66.61.6c.73.65   ; false
    @usableFromInline
    internal let falseLiteral = "false".map {
        _ in JsonValue.boolean(value: false)
    } invert: { jsonValue in
        guard case .boolean(let value) = jsonValue else {
            return nil
        }
        
        return "\(value)"
    }

    // null  = %x6e.75.6c.6c      ; null
    @usableFromInline
    internal let nullLiteral = "null".map {
        _ in JsonValue.null
    } invert: { jsonValue in
        guard case .null = jsonValue else {
            return nil
        }
        
        return "null"
    }

    // string = quotation-mark *char quotation-mark
    @usableFromInline
    internal let stringValue = StringSyntax().map {
        JsonValue.string(value: String($0))
    } invert: { jsonValue in
        guard case .string(let value) = jsonValue else {
            return nil
        }
        
        return value[...]
    }

    // number = [ minus ] int [ frac ] [ exp ]
    @usableFromInline
    internal let numberValue = Number().map {
        JsonValue.number(value: Double($0)!)
    } invert: { jsonValue in
        guard case .number(let value) = jsonValue else {
            return nil
        }
        
        return "\(value)"
    }
    
    @inlinable
    public var body: some ParserPrinter<Substring, JsonValue> {
        Parse {
            ws.defaultPrint("")
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
            ws.defaultPrint("")
        }
    }
    
    @inlinable
    init() {}
}

extension JsonParser: Sendable {}
