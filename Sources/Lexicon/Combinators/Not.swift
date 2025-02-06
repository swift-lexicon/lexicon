//
//  Not.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

public struct Not<P: Parser>: Parser
where P.Input: Collection, P.Input.SubSequence == P.Input {
    @usableFromInline let parser: P
    
    @inlinable
    public init(_ parser: P) {
        self.parser = parser
    }
    
    @inlinable
    public init(@DiscardBuilder _ builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Input, P.Input>? {
        if let _ = try parser.parse(input) {
            return nil
        }
        
        guard !input.isEmpty else {
            return nil
        }
        
        let remaining = input[input.index(after: input.startIndex)...]
        return ParseResult(input[..<remaining.startIndex], remaining)
    }
}

extension Not: Printer {
    @inlinable
    public func print(_ output: P.Input) throws -> P.Input? {
        if let _ = try parser.parse(output) {
            return nil
        }
        
        guard !output.isEmpty else {
            return nil
        }
        
        return output[..<output.index(after: output.startIndex)]
    }
}

public extension Parsers {
    typealias Not = Lexicon.Not
}
