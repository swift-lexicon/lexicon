//
//  Parser.swift
//  Parsecco
//
//  Created by Aaron Vranken on 23/01/2025.
//

import Foundation

public struct ParseResult<Result, Remaining> {
    @usableFromInline let result: Result
    @usableFromInline let remaining: Remaining
    
    @inlinable
    public init(_ result: Result, _ remaining: Remaining) {
        self.result = result
        self.remaining = remaining
    }
}

public protocol Parser<Input, Output>: ParserConvertible where ParserType == Self {
    associatedtype Input
    associatedtype Output
    
    func parse(_ input: Input) throws -> (output: Output, remainder: Input)?
}

public extension Parser
where Input == Substring {
    @inlinable
    func parse(_ input: String) throws -> Output? {
        try self.parse(input[...]).map { $0.0 }
    }
}

public extension Parser {
    @inlinable var asParser: ParserType { get { self } }
}
