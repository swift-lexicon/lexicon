//
//  Throw.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation

public struct ParseError<Input: Sendable>: Error {
    public let error: Error
    public let atSlice: Input
    
    @inlinable
    init(error: Error, at atSlice: Input) {
        self.error = error
        self.atSlice = atSlice
    }
}

public struct Throw<P: Parser>: Parser where P.Input: Sendable{
    @usableFromInline let parser: P
    @usableFromInline let throwingClosure: @Sendable () -> Error
    
    @usableFromInline
    init(_ parser: P, _ throwingClosure: @escaping @autoclosure @Sendable () -> Error) {
        self.parser = parser
        self.throwingClosure = throwingClosure
    }
    
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        guard let result = try parser.parse(input) else {
            throw ParseError(error: throwingClosure(), at: input)
        }
        return result
    }
}

extension Throw: Sendable where P: Sendable {}

extension Parser where Input: Sendable {
    @inlinable
    public func throwOnFailure(_ throwingClosure: @escaping @autoclosure @Sendable () -> Error) -> Throw<Self> {
        return Throw(self, throwingClosure())
    }
}
