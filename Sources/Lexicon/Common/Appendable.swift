//
//  Appendable.swift
//  lexicon
//
//  Created by Aaron Vranken on 02/02/2025.
//

import Foundation

public protocol Appendable: Collection {
    mutating func append(_ newElement: Element)
    mutating func append<S: Sequence>(contentsOf newElements: S) where S.Element == Element
}
