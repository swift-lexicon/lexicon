//
//  AlphaNumeric.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 Matches any character that represents a hexadecimal digit.
 */
public let hexDigit = Spot<Substring>(\.isHexDigit)

/**
 # Description
 Matches any character that is considered lowercase.
 */
public let lowerCase = Spot<Substring>(\.isLowercase)

/**
 # Description
 Matches any character that is considered uppercase.
 */
public let upperCase = Spot<Substring>(\.isUppercase)

/**
 # Description
 Matches any Unicode number character.
 */
public let number = Spot<Substring>(\.isNumber)

/**
 # Description
 Matches any ASCII number character. I.e., any arabic numeral: 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9.
 */
public let asciiNumber = Spot<Substring> {
    $0.isASCII && $0.isNumber
}

/**
 # Description
 Matches any Unicode letter character.
 */
public let letter = Spot<Substring>(\.isLetter)

/**
 # Description
 Matches any Latin letter character.
 */
public let asciiLetter = Spot<Substring> {
    $0.isASCII && $0.isLetter
}

/**
 # Description
 Matches any Unicode letter or number character.
 */
public let alphaNumeric = OneOf {
    letter
    number
}
