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
    public init(@ParserBuilder _ builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Input, P.Input>? {
        if let _ = try parser.parse(input) {
            return nil
        }
        
        var remaining = input
        guard let _ = remaining.popFirst() else {
            return nil
        }
        
        return ParseResult(input[..<remaining.startIndex], remaining)
    }
}
