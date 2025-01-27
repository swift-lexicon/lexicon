//
// Line.swift
//
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation

public let lineEnding = Spot<Substring>(\.isNewline)

public let line = Until {
    lineEnding
}
