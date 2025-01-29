//
// Line.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

public let endOfLine = Spot<Substring>(\.isNewline)

public let endOfFile = End<Substring>()

public let line = Until {
    endOfLine
}
