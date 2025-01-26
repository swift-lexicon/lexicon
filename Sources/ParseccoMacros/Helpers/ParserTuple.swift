//
//  ParserTuple.swift
//  Parsecco
//
//  Created by Aaron Vranken on 26/01/2025.
//

import Foundation

struct ParserTupleGeneric {
    let name: String
    let conformsTo: String
}

struct ParserTupleParameter {
    let name: String
    let type: ParserTupleGeneric
    let parseResult: String
}

struct ParserTupleSyntax {
    let type: String
    let parameters: [ParserTupleParameter]
    
    func getGenericsClauseContent(withConformance: Bool = true) -> String {
        return parameters
            .map({ "\($0.type.name)\(withConformance ? ": \($0.type.conformsTo)" : "")"})
            .joined(separator: ", ")
    }
    
    func getParametersClauseContent() -> String {
        return parameters.map({ "_ \($0.name): \($0.type.name)" }).joined(separator: ", ")
    }
}
