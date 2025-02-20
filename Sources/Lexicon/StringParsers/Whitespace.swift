//
//  Whitespace.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 A `Substring` parser that matches a space (" ") character.
 */
public let space = Character(" ")

public extension StringParsers {
    static let space = Lexicon.space
}

/**
 # Description
 A `Substring` parser that matches a tab ("\t") character.
 */
public let tab = Character("\t")

public extension StringParsers {
    static let tab = Lexicon.tab
}

/**
 # Description
 A `Substring` parser that matches any unicode whitespace character.
 */
public let whitespace = Spot<Substring>(\.isWhitespace)

public extension StringParsers {
    static let whitespace = Lexicon.whitespace
}

/**
 # Description
 A `Substring` parser that matches an uninterrupted sequence of unique whitespace characters.
 */
public let skipWhitespace = SkipWhile { whitespace }

public extension StringParsers {
    static let skipWhitespace = Lexicon.skipWhitespace
}
