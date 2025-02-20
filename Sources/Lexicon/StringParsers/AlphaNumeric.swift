//
//  AlphaNumeric.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

/**
 # Description
 A `Substring` parser that matches any character that represents a hexadecimal digit.
 */
public let hexDigit = Spot<Substring>(\.isHexDigit)

/**
 # Description
 A `Substring` parser that matches any character that is considered lowercase.
 */
public let lowerCase = Spot<Substring>(\.isLowercase)

/**
 # Description
 A `Substring` parser that matches any character that is considered uppercase.
 */
public let upperCase = Spot<Substring>(\.isUppercase)

/**
 # Description
 A `Substring` parser that matches any Unicode number character..
 */
public let number = Spot<Substring>(\.isNumber)

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

/**
 # Description
 A `Substring` parser that matches any Unicode letter character.
 */
public let letter = Spot<Substring>(\.isLetter)

/**
 # Description
 A `Substring` parser that matches any Latin letter character.
 */
public let asciiLetter = Spot<Substring> {
    $0.isASCII && $0.isLetter
}

/**
 # Description
 A `Substring` parser that matches any Unicode letter or number character.
 */
public let alphaNumeric = OneOf {
    letter
    number
}
