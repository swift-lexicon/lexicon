//
//  File.swift
//  Parsecco
//
//  Created by Aaron Vranken on 25/01/2025.
//

import Foundation
import XCTest

struct Book: Decodable {
    let title: String
}



final class ParseccoJsonDecoderTests: XCTestCase {
    func testMirror() throws {
//        JSONDecoder.decode(Book.self, from: "{ title: \"Hello\" }")
        let mirror = Mirror(reflecting: Book.self)
        print(mirror)
        
        for child in mirror.children {
            print("here")
            print(child.value)
            print(child.label as Any)
        }
    }
}
