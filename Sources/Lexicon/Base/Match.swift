//
//  Match.swift
//  Lexicon
//
//  Created by Aaron Vranken on 23/01/2025.
//

/**
 # Description
 The `Match` parser matches a subsequence in the collection.
 */
public struct Match<Input>: Parser
where Input: Collection, Input: Equatable, Input.Element: Equatable, Input == Input.SubSequence {
    @usableFromInline let matcher: Input
    
    @inlinable public init<I>(_ matcher: I)
    where I: Collection, Input == I.SubSequence {
        self.matcher = matcher[...]
    }
    
    @inlinable
    public func parse(_ input: Input) -> ParseResult<Input, Input>? {
        let matchee = input.prefix(matcher.count)
        if matchee == matcher {
            return ParseResult(matchee, input[matchee.endIndex...])
        }
        return nil
    }
}

extension Match: Printer {
    @inlinable
    public func print(_ output: Input) throws -> Input? {
        guard output == matcher else {
            return nil
        }
        
        return output
    }
}

extension Match: VoidPrinter {
    @inlinable
    public func print() throws -> Input? {
        return matcher
    }
}

extension Match: Sendable where Input: Sendable {}

extension String.UTF8View.SubSequence: @retroactive Equatable {
    public static func == (lhs: Substring.UTF8View, rhs: Substring.UTF8View) -> Bool {
        lhs.elementsEqual(rhs)
    }
}

public extension Parsers {
    typealias Match = Lexicon.Match
}
