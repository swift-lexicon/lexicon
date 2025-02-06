//
//  Tests.swift
//  lexicon
//
//  Created by Aaron Vranken on 06/02/2025.
//

struct TestSubstring: Parser {
    var body: some Parser<Substring, Substring> {
        Parse {
            Match("foo")
        }
    }
}

struct TestUtf8: Parser {
    var body: some Parser<Substring.UTF8View, Substring.UTF8View> {
        Parse {
            "foo".utf8
        }
    }
}

//struct TestUtf8Array: Parser {
//    var body: some Parser<ArraySlice<Character>, ArraySlice<Character>> {
//        Parse {
//            Character("a")
//        }
//    }
//}
