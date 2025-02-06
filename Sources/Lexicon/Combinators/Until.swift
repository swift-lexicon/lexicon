//
//  Until.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

public struct Until<End: Parser>: Parser
where End.Input: Collection, End.Input.SubSequence == End.Input {
    public let end: End
    
    @inlinable init(_ parser: End) {
        self.end = parser
    }
    
    @inlinable public init(@ParseBuilder builder: () -> End) {
        self.end = builder()
    }
    
    @inlinable
    public func parse(_ input: End.Input) throws -> ParseResult<End.Input, End.Input>? {
        var remaining = input
        var untilResult = try end.parse(remaining)
        
        while untilResult == nil && !remaining.isEmpty {
            _ = remaining.popFirst()
            untilResult = try end.parse(remaining)
        }
        
        return untilResult.map { ParseResult(input[..<remaining.startIndex], $0.remaining) }
    }
}

extension Until: Sendable where End: Sendable {}

extension Until: Printer
where End: VoidPrinter, End.Input: Appendable {
    @inlinable
    public func print(_ output: End.Input) throws -> End.Input? {
        guard let endInput = try end.print() else {
            return nil
        }
        var input = output
        input.append(contentsOf: endInput)
        
        return input
    }
}

public extension Parsers {
    typealias Until = Lexicon.Until
}
