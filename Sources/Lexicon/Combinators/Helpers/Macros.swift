//
//  Macros.swift
//  Lexicon
//
//  Created by Aaron Vranken on 25/01/2025.
//

// This gets used by multiple resultBuilder macros.
@attached(extension, conformances: Sendable)
public macro parseSendableConformanceMacro() = #externalMacro(module: "LexiconMacros", type: "ParseSendableConformanceMacro")
