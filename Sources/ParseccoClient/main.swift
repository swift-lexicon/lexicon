import Parsecco

let text = "Cool that you're here"
let parser = Match("Cool")

let result = try parser.parse(text)

print(result as Any)
