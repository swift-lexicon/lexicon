//
//  ParserConvertibles.swift
//  lexicon
//
//  Created by Aaron Vranken on 06/02/2025.
//

import Foundation

extension Array: ParserConvertible
where Element: Equatable {
    @inlinable
    public var asParser: Match<ArraySlice<Element>> {
        Match(self)
    }
}

extension String: ParserConvertible {
    @inlinable
    public var asParser: Match<Substring> {
        Match(self)
    }
}

extension String.UTF8View: ParserConvertible {
    @inlinable
    public var asParser: Match<Substring.UTF8View> {
        Match(self)
    }
}

extension Character: ParserConvertible {
    @inlinable
    public var asParser: Token<Substring> {
        Token<Substring>(self)
    }
}

extension UTF8.CodeUnit: ParserConvertible {
    @inlinable
    public var asParser: Token<Substring.UTF8View> {
        Token<Substring.UTF8View>(self)
    }
}
