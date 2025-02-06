//
//  File.swift
//  Lexicon
//
//  Created by Aaron Vranken on 28/01/2025.
//

import Foundation
import XCTest
import Lexicon

struct User {
    let id: Int
    let name: String
    let isAdmin: Bool
}

//let test: Parse<
//
//ParseBuilder.CaptureFirst<
//    ParseBuilder.CaptureBoth<
//        ParseBuilder.CaptureFirst<
//            Capture<
//                Token<Substring>
//            >,
//            Token<Substring>
//        >,
//        Capture<
//            Token<Substring>
//        >
//    >.CombineBoth<
//        (Substring, Substring)
//    >,
//    Token<Substring>
//>

final class LexiconPerformanceTests: XCTestCase {
    let input = """
      1,Blob,true
      2,Blob Jr.,false
      3,Blob Sr.,true
      """
    
    // 2.52s
    // 1.80s after spot, token and not refactor
    // 1.72s after variadic refactor
    func testPerformanceLexicon() throws {
        let user = Parse {
            integer.capture()
            Character(",")
            SkipWhile { Not { Character(",") } }.capture()
            Character(",")
            bool.capture()
        }.map { captures in
            User(
                id: captures.0!,
                name: String(captures.1),
                isAdmin: captures.2
            )
        }
        
        let users = ZeroOrMore {
            user.capture()
        } separator: {
            Character("\n")
        }
        
        var result: [User]?
        self.measure {
            for _ in 0...1000000 {
                result = try! users.parse(input)?.output
            }
        }
        
        print(result as Any)
    }
    
    func testSomethingElse() throws {
        let parser = Parse {
            Character("a")
            
            ZeroOrMore {
                Character("a").asParser.capture()
            }
            .capture()
        }.map({ $0 })
        
        
    }
    
    func testLongNoMatch() throws {
        let parser = Parse {
            SkipWhile { Character(" ") }
            Character("A").asParser.capture()
        }
        
        let input = String(repeating: " ", count: 5000000)
        
        var result: Substring?
        self.measure {
            result = try? parser.parse(input)?.output
        }
        
        print(result)
    }
    
    func testLongNoMatchUtf8() throws {
        let parser = Parse {
            SkipWhile {
                Token<String.UTF8View.SubSequence>(" ".utf8.first!)
            }
            Token<String.UTF8View.SubSequence>("A".utf8.first!).capture()
        }
        
        let input = String(repeating: " ", count: 5000000)
        
        var result: String.UTF8View.SubSequence?
        self.measure {
            result = try? parser.parse(input.utf8[...])?.output
        }
        
        print(result)
    }
    
    func testLongNoRegexMatch() throws {
        let regex = try Regex("^ +A")
        
        let input = String(repeating: " ", count: 5000000)
        
        var result: Regex<AnyRegexOutput>.Match?
        self.measure {
            result = try? regex.firstMatch(in: input)
        }
        
        print(result)
    }
//
//    // 1.83s surprisingly
//    func testPerformanceLexiconInlineDeclaration() throws {
//        var result: [User]?
//        self.measure {
//            for _ in 0...1000000 {
//                let user = Parse {
//                    integer.capture()
//                    Character(",")
//                    SkipWhile { Not { Character(",") } }.capture()
//                    Character(",")
//                    bool.capture()
//                }.map {
//                    User(
//                        id: $0.captures.0,
//                        name: String($0.captures.1),
//                        isAdmin: $0.captures.2
//                    )
//                }
//                
//                let users = ZeroOrMore {
//                    user.capture()
//                } separator: {
//                    Character("\n")
//                }.map { $0.map(\.captures) }
//                
//                result = try! users.parse(input)?.output
//            }
//        }
//        
//        print(result as Any)
//    }
//    
//    // 1.24s
//    func testPerformanceLexiconUtf8() throws {
//        let user = Parse {
//            integerUtf8.capture()
//            Token<String.UTF8View.SubSequence>(",".utf8.first!)
//            SkipWhile { Not { Token<String.UTF8View.SubSequence>(",".utf8.first!) } }.capture()
//            Token<String.UTF8View.SubSequence>(",".utf8.first!)
//            OneOf {
//                Match("true".utf8).map { _ in true }
//                Match("false".utf8).map {_ in false }
//            }.capture()
//        }.map {
//            User(
//                id: $0.captures.0,
//                name: String($0.captures.1)!,
//                isAdmin: $0.captures.2
//            )
//        }
//        
//        let users = ZeroOrMore {
//            user.capture()
//        } separator: {
//            Token<String.UTF8View.SubSequence>("\n".utf8.first!)
//        }.map { $0.map(\.captures) }
//        
//        var result: [User]?
//        self.measure {
//            for _ in 0...1000000 {
//                result = try! users.parse(input.utf8[...])?.output
//            }
//        }
//        
//        print(result as Any)
//    }
////    
////    
//    func testPerformanceScanner() throws {
//        
//        self.measure {
//            for _ in 0...1000000 {
//                var users: [User] = []
//                let scanner = Scanner(string: input)
//                while scanner.currentIndex != input.endIndex {
//                    guard
//                        let id = scanner.scanInt(),
//                        let _ = scanner.scanString(","),
//                        let name = scanner.scanUpToString(","),
//                        let _ = scanner.scanString(","),
//                        let isAdmin = scanner.scanBool()
//                    else { break }
//                    
//                    
//                    users.append(User(id: id, name: name, isAdmin: isAdmin))
//                    _ = scanner.scanString("\n")
//                }
//            }
//        }
//    }
}


extension Scanner {
  @available(macOS 10.15, *)
  func scanBool() -> Bool? {
    self.scanString("true").map { _ in true }
      ?? self.scanString("false").map { _ in false }
  }
}

public let integerUtf8 = SkipWhile { asciiNumberUtf8 }.map({ Int(String($0)!)! })

public let asciiNumberUtf8 = Spot<String.UTF8View.SubSequence>{
    return $0 >= 0x30 && $0 <= 0x39
}
