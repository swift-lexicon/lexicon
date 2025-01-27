//
//  Spot.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 This matches a single token if it fulfills the provided condition.
 */
public struct Spot<Input: Collection>: Parser, Sendable
where Input == Input.SubSequence {
    @usableFromInline let predicate: @Sendable (Input.Element) throws -> Bool
    
    @inlinable public init(_ predicate: @Sendable @escaping (Input.Element) throws -> Bool) {
        self.predicate = predicate
    }
    
    @inlinable public func parse(_ input: Input) throws -> ParseResult<Input, Input>? {
        var remaining = input
        if let first = remaining.popFirst(), try predicate(first) {
            return ParseResult(input[..<remaining.startIndex], remaining)
        }
        return nil
    }
}
