//
//  End.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

public struct End<Input: Collection>: Parser, Sendable {
    @inlinable public init() {}
    
    @inlinable public func parse(_ input: Input) -> ParseResult<Input, Input>? {
        if input.isEmpty {
            return ParseResult(input, input)
        }
        return nil
    }
}

extension End: Printer {
    @inlinable
    public func print(_ output: Input) throws -> Input? {
        guard output.isEmpty else {
            return nil
        }
        
        return output
    }
}

extension End: VoidPrinter
where Input: EmptyInitializable {
    @inlinable
    public func print() throws -> Input? {
        Input.initEmpty()
    }
}

public extension Parsers {
    typealias End = Lexicon.End
}
