//
//  Token.swift
//  Lexicon
//
//  Created by Aaron Vranken on 24/01/2025.
//

/**
 # Description
 The `Token` parser matches a single token in the collection.
 */
public struct Token<Input>: Parser
where Input: Collection, Input.Element: Equatable, Input == Input.SubSequence {
    @usableFromInline let token: Input.Element
    
    @inlinable
    public init<T>(_ token: T)
    where Input.Element == T {
        self.token = token
    }
    
    @inlinable
    public func parse(_ input: Input) -> ParseResult<Input, Input>? {
        guard !input.isEmpty else {
            return nil
        }
        
        let first = input[input.startIndex]
        if first == token {
            let remaining = input[input.index(after: input.startIndex)...]
            return ParseResult(input[..<remaining.startIndex], remaining)
        }
        return nil
    }
}

extension Token: Sendable where Input.Element: Sendable {}

extension Token: Printer {
    @inlinable
    public func print(_ output: Input) throws -> Input? {
        guard output.count == 1,
              output[output.startIndex] == token else {
            return nil
        }
        
        return output
    }
}

extension Token: VoidPrinter
where Input: EmptyInitializable & Appendable {
    @inlinable
    public func print() throws -> Input? {
        var input = Input.initEmpty()
        input.append(token)
        
        return input
    }
}

public extension Parsers {
    typealias Token = Lexicon.Token
}
