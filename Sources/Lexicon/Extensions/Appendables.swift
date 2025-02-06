//
//  Appendables.swift
//  lexicon
//
//  Created by Aaron Vranken on 06/02/2025.
//

extension Substring: Appendable {}
extension ArraySlice: Appendable {}

extension Substring.UTF8View: Appendable {    
    public mutating func append(_ newElement: String.UTF8View.Element) {
        self = (Substring(self) + String(newElement)).utf8
    }
    
    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, String.UTF8View.Element == S.Element {
        self = (Substring(self) + String(decoding: newElements.map { $0 }, as: UTF8.self)).utf8
    }
}
