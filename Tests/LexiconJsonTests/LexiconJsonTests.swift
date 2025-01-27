import XCTest
import LexiconJson

let input = """
{
    "id": "0001",
    "type": "donut",
    "name": "Cake",
    "ppu": 0.55,
    "batters":
        {
            "batter":
                [
                    { "id": "1001", "type": "Regular" },
                    { "id": "1002", "type": "Chocolate" },
                    { "id": "1003", "type": "Blueberry" },
                    { "id": "1004", "type": "Devil's Food" }
                ]
        },
    "topping":
        [
            { "id": "5001", "type": "None" },
            { "id": "5002", "type": "Glazed" },
            { "id": "5005", "type": "Sugar" },
            { "id": "5007", "type": "Powdered Sugar" },
            { "id": "5006", "type": "Chocolate with Sprinkles" },
            { "id": "5003", "type": "Chocolate" },
            { "id": "5004", "type": "Maple" }
        ]
}
"""

final class LexiconJsonTests: XCTestCase {
    // 1.26s for 10,000
    func testJsonParser() throws {
        var result: JsonValue?
        self.measure {
            for _ in 0..<10000 {
                result = try! jsonParser.parse(input)
            }
        }
        print(result)
    }
    
    // 1.18s for 10,000
    func testJsonParserUtf8() throws {
        var result: JsonValue?
        self.measure {
            for _ in 0..<10000 {
                let input = input.data(using: .utf8)!
                result = try! jsonParserUtf8.parse(input)?.output
            }
        }
        print(result)
    }
    
    // 0.0756s for 10,000
    func testJsonSerialization() throws {
        var result: [String: Any]?
        self.measure {
            for _ in 0..<10000 {
                let input = input.data(using: .utf8)!
                result = try? JSONSerialization.jsonObject(with: input, options: []) as? [String: Any]
            }
        }
        print(result)
    }
    
    // 0.169s for 10,000
    func testJsonDecoderParser() throws {
        let decoder = JSONDecoder()
        
        var result: Confectionary?
        self.measure {
            for _ in 0..<10000 {
                let input = input.data(using: .utf8)!
                result = try! decoder.decode(Confectionary.self, from: input)
            }
        }
        print(result)
    }
}

struct Confectionary: Codable {
    let id: String
    let type: String
    let name: String
    let ppu: Double
    let batters: Batters
    let topping: [Topping]
}

struct Batters: Codable {
    let batter: [Batter]
}

struct Batter: Codable {
    let id: String
    let type: String
}

struct Topping: Codable {
    let id: String
    let type: String
}

struct Book: Codable {
    let title: String
    let metadata: BookMetadata
}

struct BookMetadata: Codable {
    let createdAt: String
}
