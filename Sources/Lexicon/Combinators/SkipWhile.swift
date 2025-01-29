//
//  While.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 Keeps consuming tokens until the provided condition is no longer true.
 */
public struct SkipWhile<P: Parser>: Parser
where P.Input: Collection, P.Input.SubSequence == P.Input {
    @usableFromInline let parser: P
    
    @inlinable public init(_ parser: P) {
        self.parser = parser
    }
    
    @inlinable public init(@ParserBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> ParseResult<P.Input, P.Input>? {
        var remaining = input
        
        while let newRemaining = try parser.parse(remaining)?.remaining {
            remaining = newRemaining
        }
        
        return ParseResult(input[..<remaining.startIndex], remaining)
    }
}

extension SkipWhile: Sendable where P: Sendable {}
