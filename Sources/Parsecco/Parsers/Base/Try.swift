//
//  Try.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 This is an optional parser.
 If the wrapper parser succeeds, this will return the same output value.
 If the wrapper parser fails, this will return a nil value.
 */
public struct Try<P: Parser>: Parser {
    @usableFromInline let parser: P
    
    public init(_ parser: P) {
        self.parser = parser
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> (output: P.Output?, remainder: P.Input)? {
        try parser.parse(input) ?? (nil, input)
    }
}

extension Try: ParserConvertible {
    public var asParser: Self {
        self
    }
}

public extension Try {
    init(@ParserBuilder builder: () -> P) {
        self.init(builder())
    }
}

extension Try: Sendable where P: Sendable {}

public extension Parser {
    func optional() -> Try<Self> {
        Try(self)
    }
}
