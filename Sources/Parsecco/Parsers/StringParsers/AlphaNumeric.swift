//
//  AlphaNumeric.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

/**
 # Description
 Matches any Unicode number character.
 */
public let matchNumeric: Spot<Substring> = Spot { $0.isNumber }

/**
 # Description
 Matches any ASCII number character. I.e., any arabic numeral: 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9.
 */
public let matchArabicNumeral: Spot<Substring> = Spot { 47 < $0.utf8.first! && $0.utf8.first! < 58 }

/**
 # Description
 Matches any Unicode letter character.
 */
public let matchAlpha: Spot<Substring> = Spot { $0.isLetter }

/**
 # Description
 Matches any Latin letter character.
 */
public let matchLatin: Spot<Substring> = Spot {
    let char = $0.utf8.first!
    return (0x41 <= char && char <= 0x5A) || (0x61 <= char && char <= 0x7A)
}


/**
 # Description
 Matches any Unicode letter or number character.
 */
public let matchAlphaNumeric = OneOf {
    matchAlpha
    matchNumeric
}
