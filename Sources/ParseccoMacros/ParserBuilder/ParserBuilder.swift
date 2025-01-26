//
//  CaptureTuple.swift
//  Parsecco
//
//  Created by Aaron Vranken on 25/01/2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

fileprivate func getParserTupleSyntax(arity: Int, conformsTo: String) -> ParserTupleSyntax {
    return ParserTupleSyntax(
        type: "ParserTuple\(arity)",
        parameters: (1...arity).map {
            ParserTupleParameter(
                name: "parser\($0)",
                type: ParserTupleGeneric(
                    name: "Parser\($0)",
                    conformsTo: conformsTo
                ),
                parseResult: "result\($0)"
            )
        }
    )
}

fileprivate func generateBuildBlock(arity: Int) -> DeclSyntax {
    let parserTupleSyntax =  getParserTupleSyntax(arity: arity, conformsTo: "ParserConvertible")
    
    return """
    @inlinable static func buildBlock<
        \(raw: parserTupleSyntax.getGenericsClauseContent())
    >(
        \(raw: parserTupleSyntax.getParametersClauseContent())
    ) -> \(raw: parserTupleSyntax.type)<\(raw: parserTupleSyntax.parameters.map({ "\($0.type.name).ParserType" }).joined(separator: ", "))> {
        \(raw: parserTupleSyntax.type)(\(raw: parserTupleSyntax.parameters.map({ "\($0.name).asParser" }).joined(separator: ", ")))
    }
    """
}

fileprivate func generateParserTuple(arity: Int) -> DeclSyntax {
    let parserTupleSyntax =  getParserTupleSyntax(arity: arity, conformsTo: "Parser")
    let firstParameter = parserTupleSyntax.parameters[0]
    let remainingParameters = parserTupleSyntax.parameters[1...]
    
    return """
    @parseSendableConformanceMacro
    struct \(raw: parserTupleSyntax.type)<\(raw: parserTupleSyntax.getGenericsClauseContent())>: Parser
    where 
        \(raw:
            remainingParameters
                .map({ "\(firstParameter.type.name).Input == \($0.type.name).Input" })
                .joined(separator: ", ")
        )
    {
        @usableFromInline let \(raw:
            parserTupleSyntax
                .parameters
                .map({ "\($0.name): \($0.type.name)"})
                .joined(separator: ", ")
        )

        @inlinable public init(\(raw: parserTupleSyntax.getParametersClauseContent())) {
            \(raw:
                parserTupleSyntax
                    .parameters
                    .map({ "self.\($0.name) = \($0.name)" })
                    .joined(separator: "\n\t\t")
            )
        }

        @inlinable public func parse(
            _ input: \(raw: firstParameter.type.name).Input
        ) throws -> (
            output: (\(raw: parserTupleSyntax.parameters.map({ "\($0.type.name).Output" }).joined(separator: ", "))), 
            remainder: \(raw: firstParameter.type.name).Input
        )? {
            let remaining = input
            if \(raw: parserTupleSyntax.parameters.map({ "let (\($0.parseResult), remaining) = try \($0.name).parse(remaining)" }).joined(separator: ", ") ) {
                return ((\(raw: parserTupleSyntax.parameters.map({ $0.parseResult }).joined(separator: ", "))), remaining)
            }
            return nil
        }
    }
    """
}
    

public struct GenerateParserBuilderMembers: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let firstToken = node.arguments?.firstToken(viewMode: .sourceAccurate)?.text,
              let maxArity = Int(firstToken),
              maxArity > 1
        else {
            throw ParseBuilderError.invalidArgument
        }
        
        var declarations: [DeclSyntax] = []
        
        for i in (2...maxArity) {
            declarations.append(generateBuildBlock(arity: i))
            declarations.append(generateParserTuple(arity: i))
        }
        
        return declarations
    }
}
