//
//  Whitespace.swift
//  
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

public let space = Character(" ")

public let tab = Character("\t")

public let whitespace = Spot<Substring>(\.isWhitespace)

public let skipWhitespace = While { whitespace }
