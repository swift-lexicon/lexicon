//
//  ParserConvertible.swift
//  Parsecco
//
//  Created by Aaron Vranken on 24/01/2025.
//

import Foundation

public protocol ParserConvertible {
    associatedtype ParserType: Parser
    
    var asParser: ParserType { get }
}

