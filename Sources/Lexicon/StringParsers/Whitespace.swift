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

/**
 # Description
 A `Substring` parser that matches a tab ("\t") character.
 */
public let tab = Character("\t")

/**
 # Description
 A `Substring` parser that matches any unicode whitespace character.
 */
public let whitespace = Spot<Substring>(\.isWhitespace)

/**
 # Description
 A `Substring` parser that matches an uninterrupted sequence of unique whitespace characters.
 */
public let skipWhitespace = SkipWhile { whitespace }
