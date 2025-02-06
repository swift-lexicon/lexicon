//
//  EmptyInitializables.swift
//  lexicon
//
//  Created by Aaron Vranken on 06/02/2025.
//

extension Substring: EmptyInitializable {
    @inlinable
    public static func initEmpty() -> Substring {
        return Self()
    }
}

extension Substring.UTF8View: EmptyInitializable {
    @inlinable
    public static func initEmpty() -> Substring.UTF8View {
        return Substring().utf8
    }
}

extension ArraySlice: EmptyInitializable {
    @inlinable
    public static func initEmpty() -> ArraySlice {
        return Self()
    }
}
