//
//  ParserConvertible.swift
//  Lexicon
//
//  Created by Aaron Vranken on 24/01/2025.
//

public protocol ParserConvertible {
    associatedtype ParserType: Parser
    
    var asParser: ParserType { get }
}

