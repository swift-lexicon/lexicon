//
//  Lazy.swift
//  Parsecco
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

public final class Lazy<Input, Output>: Parser {
    public let builder: () -> (any Parser<Input, Output>)
    public var parser: (any Parser<Input, Output>)?
    
    @inlinable
    public init(_ builder: @autoclosure @escaping () -> (any Parser<Input, Output>)) {
        self.builder = builder
    }
    
    @inlinable
    public init(_ builder: @escaping () -> (any Parser<Input, Output>)) {
        self.builder = builder
    }
    
    @inlinable
    public func parse(_ input: Input) throws -> (output: Output, remainder: Input)? {
        guard let parser else {
            let parser = builder()
            self.parser = parser
            return try parser.parse(input)
        }
        return try parser.parse(input)
    }
}

