//
//  File.swift
//  Lexicon
//
//  Created by Aaron Vranken on 28/01/2025.
//

import Foundation
import XCTest
import Lexicon
import Parsing

typealias ParsingParse = Parsing.Parse

struct User {
    let id: Int
    let name: String
    let isAdmin: Bool
}

let input = """
  1,Blob,true
  2,Blob Jr.,false
  3,Blob Sr.,true
  """

final class LexiconPerformanceTests: XCTestCase {
    func testPerformanceLexicon() throws {
        let user = Parse {
            integer.capture()
            Character(",")
            SkipWhile { Not { Character(",") } }.capture()
            Character(",")
            bool.capture()
        }.map {
            User(
                id: $0.captures.0,
                name: String($0.captures.1),
                isAdmin: $0.captures.2
            )
        }
        
        let users = ZeroOrMore {
            user.capture()
        } separator: {
            Character("\n")
        }.map { $0.map(\.captures) }
        
        var result: [User]?
        self.measure {
            for _ in 0...1000000 {
                result = try! users.parse(input)?.output
            }
        }
        
        print(result as Any)
    }
    
    func testPerformanceScanner() throws {
        
        self.measure {
            for _ in 0...100000 {
                var users: [User] = []
                let scanner = Scanner(string: input)
                while scanner.currentIndex != input.endIndex {
                    guard
                        let id = scanner.scanInt(),
                        let _ = scanner.scanString(","),
                        let name = scanner.scanUpToString(","),
                        let _ = scanner.scanString(","),
                        let isAdmin = scanner.scanBool()
                    else { break }
                    
                    
                    users.append(User(id: id, name: name, isAdmin: isAdmin))
                    _ = scanner.scanString("\n")
                }
            }
        }
    }
}


extension Scanner {
  @available(macOS 10.15, *)
  func scanBool() -> Bool? {
    self.scanString("true").map { _ in true }
      ?? self.scanString("false").map { _ in false }
  }
}
