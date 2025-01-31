//
//  Capture.swift
//  
//
//  Created by Aaron Vranken on 24/01/2025.
//

public struct Capture<P: Parser>: CapturingParser {
    @usableFromInline
    let parser: P
        
    @inlinable
    public init(_ parser: P) {
        self.parser = parser
    }
    
    @inlinable
    public init<PC: ParserConvertible>(_ builder: () -> PC)
    where P == PC.ParserType {
        self.parser = builder().asParser
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<P.Output, P.Input>? {
        return try parser.parse(input)
    }
}

extension Capture: Sendable where P: Sendable {}

public extension Parser {
    @inlinable
    func capture() -> Capture<Self> {
        return Capture(self)
    }
}
