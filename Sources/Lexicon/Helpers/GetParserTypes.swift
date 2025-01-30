//
//  GetParserTypes.swift
//  lexicon
//
//  Created by Aaron Vranken on 30/01/2025.
//

import Foundation

@inlinable
public func getParserOutputType<P: Parser>(_ parser: P) -> P.Output.Type {
    return P.Output.self
}

@inlinable
public func getParserInputType<P: Parser>(_ parser: P) -> P.Input.Type {
    return P.Input.self
}

public extension Parser {
    var inputType: Input.Type {
        getParserInputType(self)
    }
    
    var outputType: Output.Type {
        getParserOutputType(self)
    }
}
