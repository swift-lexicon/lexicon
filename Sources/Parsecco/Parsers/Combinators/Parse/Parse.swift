//
//  Parse.swift
//  Parsecco
//
//  Created by Aaron Vranken on 23/01/2025.
//

import Foundation

public struct Parse<P: Parser>: Parser {
    @usableFromInline let parser: P
    
    @inlinable public init(@ParseBuilder builder: () -> P) {
        self.parser = builder()
    }
    
    @inlinable public func parse(_ input: P.Input) throws -> (output: P.Output, remainder: P.Input)? {
        return try parser.parse(input)
    }
}

extension Parse: Sendable where P: Sendable {}
