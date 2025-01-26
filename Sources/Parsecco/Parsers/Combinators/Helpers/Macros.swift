//
//  Macros.swift
//  Parsecco
//
//  Created by Aaron Vranken on 25/01/2025.
//

// This gets used by multiple resultBuilder macros.
@attached(extension, conformances: Sendable)
macro parseSendableConformanceMacro() = #externalMacro(module: "ParseccoMacros", type: "ParseSendableConformanceMacro")
