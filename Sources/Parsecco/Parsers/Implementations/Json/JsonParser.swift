//
//  JsonParser.swift
//
//
//  Created by Aaron Vranken on 03/07/2022.
//

public struct JsonParser: Parser {
    @usableFromInline
    internal let stringParser = OneOf {
        Between { Character("\"") } and: { Character("\"") }
        Between { Character("\'") } and: { Character("\'") }
    }.transform {
        JsonValue.string(value: String($0))
    }

    @usableFromInline
    internal let numberParser = matchInteger.transform { JsonValue.number(value: Double($0)! ) }

    @usableFromInline
    internal let booleanParser = OneOf {
        Match("true").transform { _ in JsonValue.boolean(value: true) }
        Match("false").transform { _ in JsonValue.boolean(value: false) }
    }

    @usableFromInline
    internal let nullParser = Match("null").transform { _ in JsonValue.null }

    @usableFromInline
    internal var arrayParser: some Parser<Substring, JsonValue> {
        get {
            Parse {
                Character("[")
                ZeroOrMore { whitespace }
                
                ZeroOrMore {
                    Lazy { jsonValueParser }.capture()
                } separator: {
                    ZeroOrMore { whitespace }
                    Character(",")
                    ZeroOrMore { whitespace }
                }
                    .capture()
                    .transform({ $0.map(\.1) })
                
                ZeroOrMore { whitespace }
                Character("]")
            }.transform({ JsonValue.array(value: $1) })
        }
    }
    
    @usableFromInline
    internal var objectParser: some Parser<Substring, JsonValue> {
        get {
            Parse {
                Character("{")
                ZeroOrMore {
                    ZeroOrMore { whitespace }
                    OneOf {
                        Between { Character("\"") } and: { Character("\"") }
                        Between { Character("\'") } and: { Character("\'") }
                    }.capture()
                    ZeroOrMore { whitespace }
                    Character(":")
                    ZeroOrMore { whitespace }
                    Lazy { jsonValueParser }.capture()
                    ZeroOrMore { whitespace }
                }
                    .transform({ $0.map{ ($0.1, $0.2 ) } })
                    .capture()
                Character("}")
            }.transform({
                var dictionary: [String: JsonValue] = [:]
                for (key, value) in $0.1 {
                    dictionary[String(key)] = value
                }
                return JsonValue.object(value: dictionary)
            })
        }
    }
    
    @usableFromInline
    internal var jsonValueParser: some Parser<Substring, JsonValue> {
        get {
            OneOf {
                Lazy { arrayParser }
                Lazy { objectParser }
                nullParser
                booleanParser
                numberParser
                stringParser
            }
        }
    }
    
    public init() {}

    public func parse(_ input: Substring) throws -> (output: JsonValue, remainder: Substring)? {
        try jsonValueParser.parse(input)
    }
}
