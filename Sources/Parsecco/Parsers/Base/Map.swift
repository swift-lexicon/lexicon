//
//  Map.swift
//  Parsecco
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 This maps the output value of the wrapper parser to the output value of the transform function.
 */
public struct Map<P: Parser, Output>: Parser {
    @usableFromInline let parser: P
    @usableFromInline let transform: @Sendable (P.Output) throws -> Output
    
    @inlinable public init(_ parser: P, _ transform: @Sendable @escaping (P.Output) throws -> Output) {
        self.parser = parser
        self.transform = transform
    }

    @inlinable public func parse(_ input: P.Input) throws -> (output: Output, remainder: P.Input)? {
        return try parser.parse(input).map { (try transform($0), $1) }
    }
}

public extension Parser {
    @inlinable func transform<T>(_ transform: @Sendable @escaping (Output) -> T) -> Map<Self, T> {
        Map(self, transform)
    }
}

extension Map: CapturingParser where P: CapturingParser { }
extension Map: Sendable where P: Sendable {}
