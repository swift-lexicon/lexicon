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

extension Capture: Printer where P: Printer {
    @inlinable
    public func print(_ output: P.Output) throws -> P.Input? {
        try parser.print(output)
    }
}

public extension ParserConvertible {
    @inlinable
    func capture() -> Capture<Self.ParserType> {
        return Capture(self.asParser)
    }
}

public extension Parsers {
    typealias Capture = Lexicon.Capture
}
