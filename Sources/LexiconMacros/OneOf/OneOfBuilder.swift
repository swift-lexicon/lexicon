//
//  OneOfBuilder.swift
//  Lexicon
//
//  Created by Aaron Vranken on 26/01/2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

fileprivate func getOneOfParserTupleSyntax(arity: Int, conformance: String) -> ParserTupleSyntax {
    return ParserTupleSyntax(
        type: "OneOfTuple\(arity)",
        parameters: (1...arity).map {
            ParserTupleParameter(
                name: "parser\($0)",
                type: ParserTupleGeneric(
                    name: "Parser\($0)",
                    conformsTo: conformance
                ),
                parseResult: "result\($0)"
            )
        }
    )
}

fileprivate func generateOneOfTuple(arity: Int) -> DeclSyntax {
    let oneOfTupleSyntax = getOneOfParserTupleSyntax(arity: arity, conformance: "Parser")
    let firstParameter = oneOfTupleSyntax.parameters.first!
    let remainingParameters = oneOfTupleSyntax.parameters[1...]
    
    return """
    @parseSendableConformanceMacro
    struct \(raw: oneOfTupleSyntax.type)<\(raw: oneOfTupleSyntax.getGenericsClauseContent())>: Parser
    where 
        \(raw:
            remainingParameters
                .map({ "\(firstParameter.type.name).Input == \($0.type.name).Input, \(firstParameter.type.name).Output == \($0.type.name).Output" })
                .joined(separator: ", ")
        )
    {
        @usableFromInline let \(raw:
            oneOfTupleSyntax
                .parameters
                .map({ "\($0.name): \($0.type.name)"})
                .joined(separator: ", ")
        )

        @inlinable public init(\(raw: oneOfTupleSyntax.getParametersClauseContent())) {
            \(raw:
                oneOfTupleSyntax
                    .parameters
                    .map({ "self.\($0.name) = \($0.name)" })
                    .joined(separator: "\n\t\t")
            )
        }

        @inlinable public func parse(
            _ input: \(raw: firstParameter.type.name).Input
        ) throws -> ParseResult<\(raw: firstParameter.type.name).Output, \(raw: firstParameter.type.name).Input>? {
            \(raw:
                oneOfTupleSyntax
                    .parameters
                    .map({
                        "if let result = try \($0.name).parse(input) { return result }"
                    })
                    .joined(separator: "\n\t\t")
            )
            return nil
        }
    }
    """
}

fileprivate func generateOneOfBuildBlock(arity: Int) -> DeclSyntax {
    let oneOfTupleSyntax = getOneOfParserTupleSyntax(arity: arity, conformance: "ParserConvertible")
    let firstParameter = oneOfTupleSyntax.parameters.first!
    let remainingParameters = oneOfTupleSyntax.parameters[1...]
    
    return """
    @inlinable
    static func buildBlock<\(raw: oneOfTupleSyntax.getGenericsClauseContent())>(\(raw: oneOfTupleSyntax.getParametersClauseContent())) -> \(raw: oneOfTupleSyntax.type)<\(raw: oneOfTupleSyntax.parameters.map({ "\($0.type.name).ParserType" }).joined(separator: ", "))>
    where \(raw:
                remainingParameters
                    .map({ "\(firstParameter.type.name).ParserType.Input == \($0.type.name).ParserType.Input, \(firstParameter.type.name).ParserType.Output == \($0.type.name).ParserType.Output" })
                    .joined(separator: ", ")
            ) {
        return \(raw: oneOfTupleSyntax.type)(\(raw: oneOfTupleSyntax.parameters.map({ "\($0.name).asParser" }).joined(separator: ", ")))
    }
    """
}

public struct GenerateOneOfBuilderMembers: MemberMacro {
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
            declarations.append(generateOneOfBuildBlock(arity: i))
            declarations.append(generateOneOfTuple(arity: i))
        }
        
        return declarations
    }
}
