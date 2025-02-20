//
//  EmptyInitialisable.swift
//  lexicon
//
//  Created by Aaron Vranken on 02/02/2025.
//

import Foundation

public protocol EmptyInitializable: Collection {
    static func initEmpty() -> Self
}
