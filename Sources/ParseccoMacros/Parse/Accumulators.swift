//
//  Accumulators.swift
//  Parsecco
//
//  Created by Aaron Vranken on 24/01/2025.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum ParseNextType {
    case output, void
    
    func toInfixInitial() -> String {
        switch self {
        case .output: return "O"
        case .void: return "V"
        }
    }
}

public func generateParseOutputAccumulators(arity: Int) -> [DeclSyntax] {
    var declarations: [DeclSyntax] = []
    for next in [ParseNextType.output, .void] {
        let typeName = "Parse\((1..<arity).map({ _ in "O" }).joined(separator: ""))\(next.toInfixInitial())Accumulator"
        let outputGenerics = (1..<arity).map({ "Output\($0)" })
        let commaSeparatedOutputGenerics = outputGenerics.joined(separator: ", ")
        let outputResults = (1..<arity).map({ "output\($0)" })
        let commaSeparatedOutputResults = outputResults.joined(separator: ", ")
        
        switch next {
        case .void:
            declarations.append(
                """
                @inlinable static func buildPartialBlock<\(raw: commaSeparatedOutputGenerics), P0: Parser, P1: ParserConvertible>(accumulated: P0, next: P1) -> \(raw: typeName)<\(raw: commaSeparatedOutputGenerics), P0, P1.ParserType>
                where P0.Output == (P0.Input, \(raw: commaSeparatedOutputGenerics)) {
                    \(raw: typeName)(accumulated, next.asParser)
                }
                """
            )
            break;
        case .output:
            declarations.append(
                """
                @inlinable static func buildPartialBlock<\(raw: commaSeparatedOutputGenerics), P0: Parser, P1: Parser>(accumulated: P0, next: Capture<P1>) -> \(raw: typeName)<\(raw: commaSeparatedOutputGenerics), P0, P1>
                where P0.Output == (P0.Input, \(raw: commaSeparatedOutputGenerics)) {
                    \(raw: typeName)(accumulated, next.parser)
                }
                """
            )
        }
        
        declarations.append(
            """
            @parseSendableConformanceMacro
            struct \(raw: typeName)<\(raw: commaSeparatedOutputGenerics), P1: Parser, P2: Parser>: Parser
            where
                P1.Input: Collection,
                P1.Input == P1.Input.SubSequence,
                P1.Output == (P1.Input, \(raw: commaSeparatedOutputGenerics)),
                P2.Input == P1.Input
            {
                @usableFromInline let parser1: P1, parser2: P2
            
                @inlinable public init(_ parser1: P1, _ parser2: P2) {
                    self.parser1 = parser1
                    self.parser2 = parser2
                }
            
                @inlinable public func parse(_ input: P1.Input) throws -> (output: (P1.Input, \(raw: outputGenerics.joined(separator: ", "))\(raw: next == .output ? ", P2.Output" : "")), remainder: P1.Input)? {
                    let remaining = input
                    if let ((_, \(raw: commaSeparatedOutputResults)), remaining) = try parser1.parse(remaining),
                       let (\(raw: next == .output ? "output\(arity)" : "_"), remaining) = try parser2.parse(remaining) {
                        return ((input[input.startIndex ..< remaining.startIndex], \(raw: commaSeparatedOutputResults)\(raw: next == .output ? ", output\(arity)" : "")), remaining)
                    }
                    return nil
                }
            }
            """
        )
    }
    
    return declarations
}

public struct GenerateParseBuilderMembers: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let outputAccumulators = (2...10).map({ generateParseOutputAccumulators(arity: $0) }).reduce([], +)
        
        return [
            outputAccumulators
        ].reduce([], +)
    }
}
