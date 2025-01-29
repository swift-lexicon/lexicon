//
//  Bool.swift
//  Lexicon
//
//  Created by Aaron Vranken on 28/01/2025.
//

public let bool = OneOf {
    Match("true").map { _ in true }
    Match("false").map { _ in false }
}
