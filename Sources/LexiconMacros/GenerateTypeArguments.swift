//
//  GenerateTypeArguments.swift
//  Lexicon
//
//  Created by Aaron Vranken on 23/01/2025.
//

import Foundation

struct ParameterEntry {
    let index: Int
    let type: String
    let conformsTo: String?
    let name: String
    
    init(index: Int, type: String, conformsTo: String?, name: String) {
        self.index = index
        self.type = type
        self.conformsTo = conformsTo
        self.name = name
    }
}

extension Array where Element == ParameterEntry {
    func getCommaSeparatedGenericsList() -> String {
        return map({ "\($0.type)\($0.conformsTo.map({ ": \($0)"}) ?? "")" }).joined(separator: ", ")
    }
    
    func getCommaSeparatedParameters() -> String {
        return map({ "_ \($0.name): \($0.type)" }).joined(separator: ", ")
    }
}

func generateArgumentList(
    arity: Int,
    baseTypeName: String = "T",
    conformsTo: String?,
    baseArgumentName: String = "t"
) -> [ParameterEntry] {
    var arguments: [ParameterEntry] = []
    
    for i in (1...arity) {
        arguments.append(
            ParameterEntry(
                index: i,
                type: "\(baseTypeName)\(i)",
                conformsTo: conformsTo,
                name: "\(baseArgumentName)\(i)"
            )
        )
    }
    
    return arguments
}
