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
where P.Input: Collection,
      P.Input.SubSequence == P.Input
{
    @usableFromInline let parser: P
    
    @inlinable public init(@DiscardBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Input, P.Input>? {
        var remaining = input
        
        while let newRemaining = try parser.parse(remaining)?.remaining {
            remaining = newRemaining
        }
        
        return ParseResult(input[..<remaining.startIndex], remaining)
    }
}

extension SkipWhile: Printer
where P: InputPrinter, P.Input: EmptyInitializable & Appendable {
    @inlinable
    public func print(_ output: P.Input) throws -> P.Input? {
        var input = Input()
        var remaining = output
        
        while let result = try parser.printWithRemaining(remaining) {
            input.append(contentsOf: result.input)
            remaining = result.remaining
        }
        
        if !remaining.isEmpty {
            return nil
        }
        
        return input
    }
}

extension SkipWhile: Sendable where P: Sendable {}
