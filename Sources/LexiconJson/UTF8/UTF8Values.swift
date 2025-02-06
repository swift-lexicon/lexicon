//
//  Values.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

@usableFromInline
struct JsonObjectUtf8: ParserPrinter {
    // member = string name-separator value
    @inlinable
    internal var memberUtf8: some ParserPrinter<Substring.UTF8View, (Substring.UTF8View, JsonValue)> {
        Parse {
            StringSyntaxUtf8().capture()
            nameSeparatorUtf8.throwOnFailure(JsonParserError.objectMissingNameSeparator)
            JsonParserUtf8().capture()
        }
    }
    
    // object = begin-object [ member *( value-separator member ) ] end-object
    @inlinable
    internal var body: some ParserPrinter<Substring.UTF8View, JsonValue> {
        Parse {
            beginObjectUtf8
            
            ZeroOrMore {
                memberUtf8.capture()
            } separator: {
                valueSeparatorUtf8
            }
            .capture()
            
            endObjectUtf8.throwOnFailure(JsonParserError.objectMissingClosingBrace)
        }.map {
            var dictionary: [String: JsonValue] = [:]
            for (key, value) in $0 {
                dictionary[String(decoding: key, as: UTF8.self)] = value
            }
            return JsonValue.object(value: dictionary)
        } invert: {
            guard case .object(let value) = $0 else {
                return nil
            }
            
            return value.map { ($0.utf8[...], $1) }
        }
    }
    
    @inlinable
    init() {}
}

@usableFromInline
struct JsonArrayUtf8: ParserPrinter {
    // array = begin-array [ value *( value-separator value ) ] end-array
    @inlinable
    internal var body: some ParserPrinter<Substring.UTF8View, JsonValue> {
        Parse {
            beginArrayUtf8
            
            ZeroOrMore {
                JsonParserUtf8().capture()
            } separator: {
                valueSeparatorUtf8
            }
            .capture()
            
            endArrayUtf8.throwOnFailure(JsonParserError.arrayMissingClosingBracket)
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

public struct JsonParserUtf8: ParserPrinter {
    // true  = %x74.72.75.65      ; true
    @usableFromInline
    internal let trueLiteralUtf8 = Match<Substring.UTF8View>("true".utf8).map {
        _ in JsonValue.boolean(value: true)
    } invert: { jsonValue in
        guard case .boolean(let value) = jsonValue else {
            return nil
        }
        
        return "\(value)".utf8[...]
    }

    // false = %x66.61.6c.73.65   ; false
    @usableFromInline
    internal let falseLiteralUtf8 = Match<Substring.UTF8View>("false".utf8).map {
        _ in JsonValue.boolean(value: false)
    } invert: { jsonValue in
        guard case .boolean(let value) = jsonValue else {
            return nil
        }
        
        return "\(value)".utf8[...]
    }

    // null  = %x6e.75.6c.6c      ; null
    @usableFromInline
    internal let nullLiteralUtf8 = Match<Substring.UTF8View>("null".utf8).map {
        _ in JsonValue.null
    } invert: { jsonValue in
        guard case .null = jsonValue else {
            return nil
        }
        
        return "null".utf8[...]
    }

    // string = quotation-mark *char quotation-mark
    @usableFromInline
    internal let stringValueUtf8 = StringSyntaxUtf8().map {
        JsonValue.string(value: String(decoding: $0, as: UTF8.self))
    } invert: { jsonValue in
        guard case .string(let value) = jsonValue else {
            return nil
        }
        
        return value.utf8[...]
    }

    // number = [ minus ] int [ frac ] [ exp ]
    @usableFromInline
    internal let numberValueUtf8 = NumberUtf8().map {
        JsonValue.number(value: Double(String(decoding: $0, as: UTF8.self))!)
    } invert: { jsonValue in
        guard case .number(let value) = jsonValue else {
            return nil
        }
        
        return "\(value)".utf8[...]
    }
    
    @inlinable
    public var body: some ParserPrinter<Substring.UTF8View, JsonValue> {
        Parse {
            whitespaceUtf8.defaultPrint("".utf8)
            OneOf {
                JsonArrayUtf8()
                JsonObjectUtf8()
                nullLiteralUtf8
                trueLiteralUtf8
                falseLiteralUtf8
                numberValueUtf8
                stringValueUtf8
            }
            .throwOnFailure(JsonParserError.notAValidJsonValue)
            .capture()
            whitespaceUtf8.defaultPrint("".utf8)
        }
    }
    
    @inlinable
    init() {}
}

extension JsonParserUtf8: Sendable {}
