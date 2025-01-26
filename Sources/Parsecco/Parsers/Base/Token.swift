//
//  Token.swift
//  Parsecco
//
//  Created by Aaron Vranken on 24/01/2025.
//

import Foundation

/**
 # Description
 This matches a single token.
 */
public struct Token<Input>: Parser
where Input: Collection, Input.Element: Equatable, Input == Input.SubSequence {
    @usableFromInline let token: Input.Element
    
    @inlinable
    public init(_ token: Input.Element) {
        self.token = token
    }
    
    @inlinable
    public func parse(_ input: Input) -> (output: Input, remainder: Input)? {
        var remaining = input
        if let first = remaining.popFirst(), first == token {
            return (input[..<remaining.startIndex], remaining)
        }
        return nil
    }
}

extension Token: Sendable where Input.Element: Sendable {}

extension Character: ParserConvertible {
    @inlinable public var asParser: Token<Substring> {
        Token<Substring>(self)
    }
}
