import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest


#if canImport(ParseccoMacros)
import ParseccoMacros

let testMacros: [String: Macro.Type] = [
    "parseSendableConformanceMacro": ParseSendableConformanceMacro.self,
    "generateParseBuilderMembers": GenerateParseBuilderMembers.self
]
#endif

final class ParseccoMacroTestTests: XCTestCase {
    func testMacro() throws {
        #if canImport(ParseccoMacros)
        assertMacroExpansion(
            """
            #parseStructMacro(2)
            """,
            expandedSource: """
            public struct Parse1<P0: Parser>: Parser, Sendable
            where
                P0: Sendable
            {
                @usableFromInline let parser0: P0
                
                @inlinable
                public init(_ parser0: P0) {
                    self.parser0 = parser0
                }
                
                @inlinable
                public func parse(_ input: P0.Input) throws -> (output: (P0.Output), remainder: P0.Input)? {
                    let remaining = input
                    if let (result0, remaining) = try parser0.parse(remaining) {
                        return (result0, remaining)
                    }
                    
                    return nil
                }
            }
            public struct Parse2<P0: Parser, P1: Parser>: Parser, Sendable
            where
                P0: Sendable,
                P1: Sendable, P1.Input == P0.Input
            {
                @usableFromInline let parser0: P0
                @usableFromInline let parser1: P1
                
                @inlinable
                public init(_ parser0: P0, _ parser1: P1) {
                    self.parser0 = parser0
                    self.parser1 = parser1
                }
                
                @inlinable
                public func parse(_ input: P0.Input) throws -> (output: (P0.Output, P1.Output), remainder: P0.Input)? {
                    let remaining = input
                    if let (result0, remaining) = try parser0.parse(remaining),
                       let (result1, remaining) = try parser1.parse(remaining) {
                        return ((result0, result1), remaining)
                    }
                    
                    return nil
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(ParseccoMacros)
        assertMacroExpansion(
            #"""
            @generateParseBuilderMembers
            @parseMemberParserSendableConformance
            enum ParseBuilder {
            }
            """#,
            expandedSource: #"""
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSomething() throws {
//        let result = generateCaptureTuple(arity: 2)
        
//        print(result)
    }
}
