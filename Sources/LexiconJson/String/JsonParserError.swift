//
//  JsonParserError.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

import Foundation

public enum JsonParserError: Error {
    case objectMissingClosingBrace,
         objectMissingNameSeparator,
         arrayMissingClosingBracket,
         exponentialMissingDigits,
         fractionMissingDigits,
         notAValidJsonValue,
         stringMissingClosingQuotationMark
}
