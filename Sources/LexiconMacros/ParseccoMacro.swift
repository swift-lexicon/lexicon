import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum ParseBuilderError: Error {
    case invalidArgument
}

public struct ParseResultBuilderMacro: MemberMacro {
    public static func expansion(
      of node: AttributeSyntax,
      providingMembersOf declaration: some DeclGroupSyntax,
      in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let firstArgument = node.arguments?.firstToken(viewMode: .sourceAccurate)?.text,
              let maxArity = Int(firstArgument),
              maxArity > 0 else {
            throw ParseBuilderError.invalidArgument
        }
        
        var declarations: [DeclSyntax] = []
        
        for i in (1...maxArity) {
            let arguments = generateArgumentList(
                arity: i,
                baseTypeName: "P",
                conformsTo: "Parser",
                baseArgumentName: "parser"
            )
            
            let bodyElements = (0..<i).map({
                """
                if let result = try p\($0).parse($0) { return result }
                """
            })
            
            let body = bodyElements.joined(separator: "\n")
            
            declarations.append(
                """
                @inlinable
                public static func buildBlock<\(raw: arguments.getCommaSeparatedGenericsList())>(
                    \(raw: arguments.getCommaSeparatedParameters())
                ) -> ParseClosure
                where 
                    \(raw: arguments.map({ "\($0.type).Input == Input" }).joined(separator: ", ")),
                    Output == (\(raw: arguments.map(\.type).joined(separator: ", "))
                {
                    {
                        let remaining = $0
                        if 
                            \(raw: arguments.map({ "let (result\($0.index), " }).joined(separator: ",\n\t\t\t"))
                        \(raw: body)
                        return nil
                    }
                }
                """
            )
        }

        return declarations
    }
}

@main
struct LexiconPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ParseSendableConformanceMacro.self,
        GenerateParseBuilderMembers.self,
        GenerateParserBuilderMembers.self,
        GenerateOneOfBuilderMembers.self
    ]
}
