//
//  Parse.swift
//  Lexicon
//
//  Created by Aaron Vranken on 23/01/2025.
//

import Foundation

public struct Parse<P: Parser>: Parser {
    @usableFromInline let parser: P
    
    @inlinable public init(@ParseBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        return try parser.parse(input)
    }
}

extension Parse: Sendable where P: Sendable {}

public struct ParseMatchWithoutCaptures<Input> {
    public let match: Input
    
    @inlinable
    public init(_ match: Input) {
        self.match = match
    }
}

extension ParseMatchWithoutCaptures: Sendable where Input: Sendable {}

public struct ParseMatchWithCaptures<Captures, Input> {
    public let match: Input
    public let captures: Captures
    
    @inlinable
    public init(_ match: Input, _ captures: Captures) {
        self.match = match
        self.captures = captures
    }
}

extension ParseMatchWithCaptures: Sendable where Captures: Sendable, Input: Sendable {}
