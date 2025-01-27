//
//  JsonParser.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

public struct JsonParserUtf8: Parser, Sendable {
    public static let jsonValueParser = Parse {
        whitespaceUtf8
        OneOf {
            Closure(parseArrayUtf8)
            Closure(parseObjectUtf8)
            nullLiteralUtf8
            trueLiteralUtf8
            falseLiteralUtf8
            numberValueUtf8
            stringValueUtf8
        }
        .throwOnFailure(JsonParserError.notAValidJsonValue)
        .capture()
        whitespaceUtf8
    }.transform(\.captures)
    
    @inlinable
    public func parse(_ input: Data) throws -> ParseResult<JsonValue, Data>? {
        try Self.jsonValueParser.parse(input)
    }
}

public let jsonParserUtf8 = JsonParserUtf8()
