//
//  AlphaNumeric.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

public enum StringParsers {}

/**
 # Description
 A `Substring` parser that matches any character that represents a hexadecimal digit.
 */
public let hexDigit = Spot<Substring>(\.isHexDigit)

public extension StringParsers {
    static let hexDigit = Lexicon.hexDigit
}

/**
 # Description
 A `Substring` parser that matches any character that is considered lowercase.
 */
public let lowerCase = Spot<Substring>(\.isLowercase)

public extension StringParsers {
    static let lowerCase = Lexicon.lowerCase
}

/**
 # Description
 A `Substring` parser that matches any character that is considered uppercase.
 */
public let upperCase = Spot<Substring>(\.isUppercase)

public extension StringParsers {
    static let upperCase = Lexicon.upperCase
}

/**
 # Description
 A `Substring` parser that matches any Unicode number character..
 */
public let number = Spot<Substring>(\.isNumber)

public extension StringParsers {
    static let number = Lexicon.number
}


/**
 # Description
 A `Substring` parser that matches any ASCII number character. I.e., any arabic numeral: 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9.
 */
public let asciiNumber = Spot<Substring>{
    guard let token = $0.utf8.first else {
        return false
    }
    return token >= 0x30 && token <= 0x39
}

public extension StringParsers {
    static let asciiNumber = Lexicon.asciiNumber
}

/**
 # Description
 A `Substring` parser that matches any ASCII number character except 0. I.e., the arabic numerals: 1, 2, 3, 4, 5, 6, 7, 8 or 9.
 */
public let nonZeroAsciiNumber = Spot<Substring>{
    guard let token = $0.utf8.first else {
        return false
    }
    return token >= 0x31 && token <= 0x39
}

public extension StringParsers {
    static let nonZeroAsciiNumber = Lexicon.nonZeroAsciiNumber
}

/**
 # Description
 A `Substring` parser that matches any Unicode letter character.
 */
public let letter = Spot<Substring>(\.isLetter)

public extension StringParsers {
    static let letter = Lexicon.letter
}

/**
 # Description
 A `Substring` parser that matches any Latin letter character.
 */
public let asciiLetter = Spot<Substring> {
    $0.isASCII && $0.isLetter
}

public extension StringParsers {
    static let asciiLetter = Lexicon.asciiLetter
}

/**
 # Description
 A `Substring` parser that matches any Unicode letter or number character.
 */
public let alphaNumeric = OneOf {
    letter
    number
}

public extension StringParsers {
    static let alphaNumeric = Lexicon.alphaNumeric
}

