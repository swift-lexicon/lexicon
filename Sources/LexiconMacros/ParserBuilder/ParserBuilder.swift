//
//  CaptureTuple.swift
//  Lexicon
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

extension Array {
    func mapPredecessor<T>(_ transform: (Element?, Element) throws -> T) rethrows -> [T] {
        var newArray: [T] = []
        var i = 0
        while i < count {
            newArray.append(try transform(i - 1 >= 0 ? self[i-1] : nil, self[i]))
            i += 1
        }
        
        return newArray
    }
}

public func generateParserTuple(arity: Int) -> DeclSyntax {
    let parserTupleSyntax =  getParserTupleSyntax(arity: arity, conformsTo: "Parser")
    let firstParameter = parserTupleSyntax.parameters.first!
    let lastParameter = parserTupleSyntax.parameters.last!
    let remainingParameters = parserTupleSyntax.parameters[1...]
    
    return """
    @parseSendableConformanceMacro
    struct \(raw: parserTupleSyntax.type)<\(raw: parserTupleSyntax.getGenericsClauseContent())>: Parser
    \(raw: remainingParameters.isEmpty ? "" : """
    where \(
        remainingParameters
            .map({ "\(firstParameter.type.name).Input == \($0.type.name).Input" })
            .joined(separator: ", ")
    )
    """
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
        ) throws -> ParseResult<(\(raw: parserTupleSyntax.parameters.map({ "\($0.type.name).Output" }).joined(separator: ", "))), \(raw: firstParameter.type.name).Input>? {
            if \(raw: parserTupleSyntax.parameters.mapPredecessor({ "let \($1.parseResult) = try \($1.name).parse(\($0.map({ "\($0.parseResult).remaining" }) ?? "input"))" }).joined(separator: ", ") ) {
                return ParseResult((\(raw: parserTupleSyntax.parameters.map({ "\($0.parseResult).output" }).joined(separator: ", "))), \(raw: lastParameter.parseResult).remaining)
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
        
        for i in (1...maxArity) {
            declarations.append(generateBuildBlock(arity: i))
            declarations.append(generateParserTuple(arity: i))
        }
        
        return declarations
    }
}
