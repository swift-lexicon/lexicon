//
//  OneOf.swift
//  Parsecco
//
//  Created by Aaron Vranken on 26/01/2025.
//

import Foundation

public struct OneOf<P: Parser>: Parser {
    @usableFromInline let parser: P

    @inlinable
    public init(@OneOfBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> (output: P.Output, remainder: P.Input)? {
        try parser.parse(input)
    }
}

extension OneOf: Sendable where P: Sendable {}
