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

//extension Parse {
//    @inlinable
//    public static func buildBlock<P0, P1>(_ p0: P0, _ p1: P1) -> ParseClosure
//    where P0: Parser, P0.Input == Input,
//          P1: Parser, P1.Input == Input,
//          Output == (P0.Output, P1.Output) {
//        {
//            if let (result0, remaining) = try p0.parse($0),
//               let (result1, remaining) = try p1.parse(remaining) {
//                return ((result0, result1), remaining)
//            }
//            return nil
//        }
//    }
//}

@main
struct ParseccoPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ParseSendableConformanceMacro.self,
        GenerateParseBuilderMembers.self,
        GenerateParserBuilderMembers.self,
        GenerateOneOfBuilderMembers.self
    ]
}
