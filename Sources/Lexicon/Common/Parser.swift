//
//  Parser.swift
//  Lexicon
//
//  Created by Aaron Vranken on 23/01/2025.
//

public struct ParseResult<Result, Remaining> {
    public let output: Result
    public let remaining: Remaining
    
    @inlinable
    public init(_ result: Result, _ remaining: Remaining) {
        self.output = result
        self.remaining = remaining
    }
}

extension ParseResult: Sendable where Result: Sendable, Remaining: Sendable {}

public protocol Parser<Input, Output>: ParserConvertible where ParserType == Self {
    associatedtype Input
    associatedtype Output
    
    associatedtype Body

    var body: Body { get }
    
    func parse(_ input: Input) throws -> ParseResult<Output, Input>?
}

public extension Parser
where Input == Substring {
    @inlinable
    func parse(_ input: String) throws -> ParseResult<Output, Substring>? {
        try self.parse(input[...])
    }
}

extension Parser where Body == Never {
    @inlinable
    public var body: Body {
        fatalError(
            """
            '\(Self.self)' has no body. 
            A parser must either define a body or a parse function.
            """
        )
    }
}

public extension Parser
where Body: Parser<Input, Output> {
    @inlinable
    func parse(_ input: Body.Input) throws -> ParseResult<Body.Output, Body.Input>? {
        try self.body.parse(input)
    }
}

public extension Parser {
    @inlinable var asParser: ParserType { get { self } }
}
