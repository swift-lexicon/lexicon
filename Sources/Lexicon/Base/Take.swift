//
//  Take.swift
//  lexicon
//
//  Created by Aaron Vranken on 30/01/2025.
//

import Foundation

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
