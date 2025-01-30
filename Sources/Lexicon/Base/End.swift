//
//  End.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

public struct End<Input: Collection>: Parser, Sendable {
    @inlinable public init() {}
    
    @inlinable public func parse(_ input: Input) -> ParseResult<Input, Input>? {
        if input.isEmpty {
            return ParseResult(input, input)
        }
        return nil
    }
}
