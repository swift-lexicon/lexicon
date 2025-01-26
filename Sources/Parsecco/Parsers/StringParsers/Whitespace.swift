//
//  Whitespace.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

public let space = Character(" ")

public let whitespace = Spot<Substring> { $0.isWhitespace }

public let tab = Character("\t")
