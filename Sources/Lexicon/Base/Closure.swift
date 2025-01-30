//
//  Closure.swift
//  Lexicon
//
//  Created by Aaron Vranken on 26/01/2025.
//

public struct Closure<Input, Output>: Parser, Sendable {
    @usableFromInline let closure: @Sendable (Input) throws -> ParseResult<Output, Input>?
    
    @inlinable
    public init(_ closure: @Sendable @escaping (Input) throws -> ParseResult<Output, Input>?) {
        self.closure = closure
    }
    
    @inlinable
    public func parse(_ input: Input) throws -> ParseResult<Output, Input>? {
        try closure(input)
    }
}
