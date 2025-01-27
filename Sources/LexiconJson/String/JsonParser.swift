//
//  JsonParser.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation
import Lexicon

public struct JsonParser: Parser, Sendable {    
    public static let jsonValueParser = Parse {
        whitespace
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
        whitespace
    }.transform(\.captures)
    
    @inlinable
    public func parse(_ input: Substring) throws -> ParseResult<JsonValue, Substring>? {
        try Self.jsonValueParser.parse(input)
    }
}

public let jsonParser = JsonParser()
