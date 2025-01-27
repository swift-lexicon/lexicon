//
//  NeverParser.swift
//  
//
//  Created by Aaron Vranken on 26/01/2025.
//

import Foundation

public struct NeverParser<Input>: Parser {
    private init(_ input: Input.Type) {}
    
    @inlinable public func parse(_ input: Input) throws -> ParseResult<Never, Input>? {
        fatalError("A NeverParser cannot be executed.")
    }
}

extension NeverParser: Sendable {}
