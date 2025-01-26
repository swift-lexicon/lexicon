//
//  End.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

public struct End<Input: Collection>: Parser, Sendable {
    @inlinable public init() {}
    
    @inlinable public func parse(_ input: Input) -> (output: Void, remainder: Input)? {
        if input.isEmpty {
            return ((), input)
        }
        return nil
    }
}
