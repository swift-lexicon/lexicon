//
//  Json.swift
//
//
//  Created by Aaron Vranken on 03/07/2022.
//

import Foundation

public struct JsonField {
    let name: String
    let value: JsonValue
}

public enum JsonValue {
    case string(value: String)
    case number(value: Double)
    case array(value: [JsonValue])
    case object(value: [String: JsonValue])
    case boolean(value: Bool)
    case null
}
