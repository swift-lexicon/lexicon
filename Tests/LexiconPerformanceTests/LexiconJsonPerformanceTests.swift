import Foundation
import XCTest
import LexiconJson
import Lexicon

final class LexiconJsonPerformanceTests: XCTestCase {
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
    
    struct Confectionary: Codable {
        let id: String
        let type: String
        let name: String
        let ppu: Double
        let batters: Batters
        let topping: [Batter]
    }
    
    struct Batters: Codable {
        let batter: [Batter]
    }
    
    struct Batter: Codable {
        let id: String
        let type: String
    }
    
    func testPerformanceLexicon() throws {
        var result: JsonValue?
        
        self.measure {
            for _ in 0...10000 {
                result = try! jsonParser.parse(input)?.output
            }
        }
        
        print(result!)
    }
    
    func testPerformanceLexiconUtf8() throws {
        var result: JsonValue?
        
//        do {
//            let result = try jsonParserUtf8.parse(input.utf8)
//        } catch ParseError<Error, Substring.UTF8View>.criticalFailure(let error, let at) {
//            print("Error \(error) at '\(String(decoding: at, as: UTF8.self))'")
//        }
        
        self.measure {
            for _ in 0...10000 {
                result = try! jsonParserUtf8.parse(input.utf8)?.output
            }
        }
        
        print(result!)
    }
    
    func testPerformanceLexiconPrint() throws {
        let parseResult = try! jsonParser.parse(input)?.output
        
        var printResult: Substring?
        self.measure {
            for _ in 0...10000 {
                printResult = try! jsonParser.print(parseResult!)
            }
        }
        
        print(printResult!)
    }
    
    func testPerformanceJSONDecoder() throws {
        var result: Confectionary?
        self.measure {
            for _ in 0...10000 {
                result = try! JSONDecoder().decode(
                    Confectionary.self,
                    from: input.data(using: .utf8)!
                )
            }
        }
        
        print(result as Any)
    }
    
    func testPerformanceJSONSerializable() throws {
        var result: Any?
        self.measure {
            for _ in 0...10000 {
                result = try! JSONSerialization.jsonObject(with:
                    input.data(using: .utf8)!
                )
            }
        }
        
        print(result as Any)
    }
}
