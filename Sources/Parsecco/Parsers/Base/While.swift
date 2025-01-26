//
//  While.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 Keeps consuming tokens until the provided condition is no longer true.
 */
public struct While<Input: Collection>: Parser, Sendable
where Input == Input.SubSequence {
    @usableFromInline let predicate: @Sendable (Input.Element) throws -> Bool
    
    @inlinable public init(_ predicate: @escaping @Sendable (Input.Element) throws -> Bool) {
        self.predicate = predicate
    }
    
    @inlinable public func parse(_ input: Input) throws -> (output: Input, remainder: Input)? {
        let result = try input.prefix(while: predicate)
        
        return (result, input[result.endIndex...])
    }
}
