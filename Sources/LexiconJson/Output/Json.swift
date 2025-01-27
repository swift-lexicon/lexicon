//
//  Json.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

public struct JsonField: Sendable {
    let name: String
    let value: JsonValue
}


public enum JsonValue: Sendable {
    case string(value: String)
    case number(value: Double)
    case array(value: [JsonValue])
    case object(value: [String: JsonValue])
    case boolean(value: Bool)
    case null
}
