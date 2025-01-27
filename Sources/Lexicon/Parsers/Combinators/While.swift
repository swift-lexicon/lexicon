//
//  While.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 Keeps consuming tokens until the provided condition is no longer true.
 */
public struct While<P: Parser>: Parser
where P.Input: Collection, P.Input.SubSequence == P.Input {
    @usableFromInline let parser: P
    
    @inlinable public init(_ parser: P) {
        self.parser = parser
    }
    
    @inlinable public init(@ParserBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> ParseResult<P.Input, P.Input>? {
        var remaining: P.Input?
        
        while let result = try parser.parse(remaining ?? input) {
            remaining = result.remaining
        }
        
        guard let remaining else {
            return ParseResult(input[input.startIndex..<input.startIndex], input)
        }
        
        return ParseResult(input[input.startIndex ..< remaining.startIndex], remaining)
    }
}

extension While: Sendable where P: Sendable {}
