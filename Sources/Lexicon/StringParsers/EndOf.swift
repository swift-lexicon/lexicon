//
// Line.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 A `Substring` parser that matches newline grapheme clusters.
 */
public let endOfLine = Spot<Substring>(\.isNewline)

public extension StringParsers {
    static let endOfLine = Lexicon.endOfLine
}

/**
 # Description
 A `Substring` parser that matches an emtpy `Substring`.
 */
public let endOfFile = End<Substring>()

public extension StringParsers {
    static let endOfFile = Lexicon.endOfFile
}

/**
 # Description
 A `Substring` parser that matches a line (until the next newline or end of file).
 */
public let line = Until {
    OneOf {
        endOfLine
        endOfFile
    }
}

public extension StringParsers {
    static let line = Lexicon.line
}
