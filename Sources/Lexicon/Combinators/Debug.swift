//
//  Debug.swift
//  Lexicon
//
//  Created by Aaron Vranken on 26/01/2025.
//

public struct Debug<P: Parser>: Parser {
    @usableFromInline let parser: P
    @usableFromInline let beforeClosure: (P.Input) -> ()
    @usableFromInline let afterClosure: (ParseResult<P.Output, P.Input>?) -> ()
    
    @inlinable
    public init(
        _ parser: P,
        before beforeClosure: @escaping (P.Input) -> (),
        after afterClosure: @escaping (ParseResult<P.Output, P.Input>?) -> ()
    ) {
        self.parser = parser
        self.beforeClosure = beforeClosure
        self.afterClosure = afterClosure
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        beforeClosure(input)
        let result = try parser.parse(input)
        afterClosure(result)
        return result
    }
}

public extension Parser {
    @inlinable
    func debug(before: @escaping (Input) -> (), after: @escaping (ParseResult<Output, Input>?) -> ()) -> Debug<Self> {
        .init(self, before: before, after: after)
    }
}
