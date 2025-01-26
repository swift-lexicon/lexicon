//
//  ParseSendableConformance.swift
//  Parsecco
//
//  Created by Aaron Vranken on 25/01/2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

func getGenericParameters(_ declaration: some DeclGroupSyntax) -> [String]? {
    guard let genericParametersClause = declaration
        .root
        .children(viewMode: .all)
        .first(where: { $0.is(GenericParameterClauseSyntax.self)})?
        .as(GenericParameterClauseSyntax.self) else {
            return nil
    }
    
    let genericParameters = genericParametersClause.parameters.map({ $0.name.text })
    
    return genericParameters
}

public struct ParseSendableConformanceMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let genericParameters = getGenericParameters(declaration) else {
            throw ParseBuilderError.invalidArgument
        }
        
        return [
            try! ExtensionDeclSyntax(
                """
                extension \(type.trimmed): Sendable 
                where \(raw: genericParameters.map({ "\($0): Sendable" }).joined(separator: ", ")) {}
                """
            )
        ]
    }
}
