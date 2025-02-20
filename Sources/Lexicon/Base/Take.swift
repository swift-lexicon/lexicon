//
//  Take.swift
//  lexicon
//
//  Created by Aaron Vranken on 30/01/2025.
//

import Foundation

/**
 # Description
 The `Take` parser takes a certain number of tokens and returns the consumed tokens.
 */
public struct Take<Input>: Parser
where Input: Collection, Input == Input.SubSequence {
    @usableFromInline let count: Int
    
    @inlinable
    public init(_ count: Int) {
        self.count = count
    }
    
    @inlinable
    public func parse(_ input: Input) -> ParseResult<Input, Input>? {
        if count == 1 {
            guard !input.isEmpty else {
                return nil
            }
            
            let remaining = input[input.index(after: input.startIndex)...]
            return ParseResult(input[..<remaining.startIndex], remaining)
        } else {
            if let result = input.index(
                input.startIndex,
                offsetBy: count,
                limitedBy: input.endIndex
            ) {
                return ParseResult(input[..<result], input[result...])
            }
        }
        return nil
    }
}

extension Take: Printer {
    @inlinable
    public func print(_ output: Input) throws -> Input? {
        guard output.count == count else {
            return nil
        }
        
        return output
    }
}

public extension Parsers {
    typealias Take = Lexicon.Take
}
