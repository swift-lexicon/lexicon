//
//  Spot.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 The `Spot` parser matches a single token if the provided predicate is true.
 */
public struct Spot<Input: Collection>: Parser, Sendable
where Input == Input.SubSequence {
    @usableFromInline let predicate: @Sendable (Input.Element) throws -> Bool
    
    @inlinable public init(_ predicate: @Sendable @escaping (Input.Element) throws -> Bool) {
        self.predicate = predicate
    }
    
    @inlinable public func parse(_ input: Input) throws -> ParseResult<Input, Input>? {
        guard !input.isEmpty else {
            return nil
        }
        
        let first = input[input.startIndex]
        if try predicate(first) {
            let remaining = input[input.index(after: input.startIndex)...]
            return ParseResult(input[..<remaining.startIndex], remaining)
        }
        return nil
    }
}

extension Spot: Printer {
    @inlinable
    public func print(_ output: Input) throws -> Input? {
        guard output.count == 1,
              try predicate(output[output.startIndex]) else {
            return nil
        }
        
        return output
    }
}

public extension Parsers {
    typealias Spot = Lexicon.Spot
}
