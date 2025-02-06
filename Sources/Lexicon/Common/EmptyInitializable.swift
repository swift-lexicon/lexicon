//
//  EmptyInitialisableCollection.swift
//  lexicon
//
//  Created by Aaron Vranken on 02/02/2025.
//

import Foundation

public protocol EmptyInitializable: Collection {
    static func initEmpty() -> Self
}

extension Substring: EmptyInitializable {
    @inlinable
    public static func initEmpty() -> Substring {
        return Self()
    }
}

extension ArraySlice: EmptyInitializable {
    @inlinable
    public static func initEmpty() -> ArraySlice {
        return Self()
    }
}
