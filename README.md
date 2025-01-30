# Lexicon: The Swift Parser Combinator

Lexicon is a Swift parser library that enables developers to quickly develop complex parsers with great performance. With Lexicon, you can create modular parsers and combine them together to handle complex use-cases, all using result builders and an intuitive syntax!

Why use Lexicon? The main reason to prefer Lexicon over other Swift parsing libraries (there aren't that many) is that Lexicon was written from the ground up to provide consistent great performance without compromising on ease of use. This means that Lexicon parsers are easy to write and understand, while still executing faster than any other Swift parser library out there.


## Package

The library does not yet have a production release, but you can play around with it already by adding the prerelease dependency to your package:

```
dependencies: [
    .package(url: "https://github.com/swift-lexicon/lexicon", exact: "0.5.0-prerelease-2025-01-29")
],
```

You then specify the target dependency as follows:

```
.target(
    name: <your package target>,
    dependencies: [
        .product(name: "Lexicon", package: "lexicon")
    ]
),
```

The current platform requirements are:

```
platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
```

There is currently an open issue to consider lowering these by using code generation instead of macros.

## Your first parser

Let’s say you want to parse a small comma separated list, with Lexicon this is easy:

```swift
let listOfNames = "alex,lottie,steven,ainslie,david"

let commaSeparatedParser = ZeroOrMore {
    SkipWhile {
        Not {
            Character(",")
        }
    }
} separator: {
    Character(",")
}.transform { $0.map(\.match) }

let names = try commaSeparatedParser.parse(listOfNames)?.output

print(names)
// Optional(["alex", "lottie", "steven", "ainslie", "david"])
```

> As you can see, the parsing syntax is declarative and largely matches a natural language description of what we want to do. 

Now this is great already, but we could easily do this with the normal String.split method. Imagine, however, that some people have a “,” as part of their name field. In this case, parsing becomes a little more complicated and the split method will return a faulty result:

```swift
let listOfNames = "alex,lottie,\"smith,steven\",ainslie,david"

print(listOfNames.split(separator: ","))
// Wrong result!
// ["alex", "lottie", "\"smith", "steven\"", "ainslie", "david"]
```

However, for us this is not an issue, we simply create a new `quotedField` parser:

```swift
let quotedField = Parse {
    Character("\"")
    SkipWhile {
        Not { Character("\"") }
    }.capture()
    Character("\"")
}.transform(\.captures)
```

And move our old body into an `unquotedField` parser:

```swift
let unquotedField = SkipWhile {
    Not {
        Character(",")
    }
}
```

Our parser will now look like:

```swift
let commaSeparatedParser = ZeroOrMore {
    OneOf {
        quotedField
        unquotedField
    }.capture()
} separator: {
    Character(",")
}.transform { $0.map(\.captures) }

let names = try commaSeparatedParser.parse(listOfNames)?.output

print(names)
// Right result!
// Optional(["alex", "lottie", "smith,steven", "ainslie", "david"])
```

Yay! We’re getting the right result. We can keep extending this parser to support escape characters, multiple lines, and whitespaces without too much effort. In fact, I used it to create an RFC 8259 compliant JSON parser in just one day!

## Performance

Performance is hugely important when deciding on which parser to use. Lexicon aims to provide a middle ground between parsing speed and development speed. It provide great performance and is easy to develop in. The reason why Lexicon can provide such good performance is because it does not use any type erasure. This enables the compiler to heavily inline and optimise the resulting parsers. 

Because of these compiler optimisations—and the performant base parsers included in Lexicon—you will almost always get *great* performance using Lexicon parsers. Great, not perfect. A well-thought-out custom handwritten parser will still outperform a Lexicon parser, though at the expense of a lot of development time and mistakes along the way. 

I will add performance comparisons later, from preliminary testing you can expect between 2x to  more than 10x better performance than SwiftParsing, depending on parser complexity, with more complex parsers performing a lot better. 

## Future Plans

### Add Printer Functionality

This should be relatively easy.

### Adding enhanced parsing information

When parsing we might want to know how far we are in the input, for strings this would be the line and column, for arrays the index. This can be done by wrapping parsing input in a special collection and defining the parsing operations as part of this collection. 

### QoL for Recursive Parsers

Currently defining recursive parsers involves some boilerplate code that could probably be refactored away. 

### Minor Performance Improvements

There is possibly still some finessing possible when it comes to performance. I’m thinking mostly of removing redundant structs in the parser hierarchy where possible so as to remove the depth of the call stack. If anyone has any concrete suggestions, I am more than willing to listen!

### Adding Fault-Tolerance to Lexicon

Ideally, on a failure to parse a critical piece of syntax, we do not always want to throw an error right there and then and stop the whole parsing function. Instead, we might wish to save this error and try to save the parsing process in as much as possible. These errors would need to be accumulated by the parser combinators until a suitable point (after parse completion or when reaching a critical failure) at which point all error can be returned. (This would involve extending the ParseResult to include an errors field and having a robust way of accumulating these errors on the combinator level.) 

Currently I do not yet have a full picture in mind for how to accomplish this, but I have multiple ideas that are workable. This is a somewhat larger undertaking and will be reserved until fully fleshed out.

## Small Notes That I Want To Add Because This Is My Page and You Can’t Stop Me

### Why Swift?

Extended grapheme clusters, they are great. Most parsers will operate on strings and most string parsing will depend on user perceived graphemes (visually distinct characters), to have native language support for such characters is a huge boon. This was one of the main reasons for me as to why I chose Swift over Rust or Haskell.

That is not the only reason however. I was also quite annoyed at the lack of any performant parser libraries in Swift. This did not make any sense to me, parser combinator libraries are quite simple to write and almost everyone else was overcomplicating them, so I decided to write my own.

### String vs String.UTF8View 

In general it is true that a parser that parses only the UTF8View of a string will be quite a bit faster than one that parses the extended grapheme clusters. Does this means that you should always use a UTF8View? It depends. 

If the use-case only depends on UTF8 code points, then sure, this is an easy and quick performance gain. Examples here might be JSON or Markdown parsers. However, if you are doing anything where extended grapheme clusters might be important, such as handling scripts where the same character could be represented using multiple combinations of UTF8 codepoints, or where specific codepoints can be used in a standalone fashion or as part of a compound character, then I would strongly advise using Substring parsers. 

By default, all the convenience parsers bundled with the library are Substring parsers as I believe this is best for general usage and to make sure this library does not give preferential treatment to the latin ASCII alphabet.

### Passing Parameters: `inout Substring` Vs `Substring`

Something I come across often when looking at Swift parsers is their abundant usage of `inout`. This is presumably to increase the performance of their parsers by simply passing in a pointer instead of a full struct. 

After extensive performance testing, I can unequivocally say that this is completely unnecessary for almost all parsing use cases and certainly when working with Substrings. I did not see any performance difference whatsoever when parsing common data types and I would love to know why. 

### What Did Make a Difference

The main tip I could give for writing performant code in Swift is this: 

Let the compiler know what you’re up to.

For this project, most of the performance gains were due to playing nicely with the type system and ensuring that the compiler can always figure out the full type of the parsers. This allows the compiler to heavily optimise how the parsers are used and specialised into concrete types. Because of the extensive use of variadic functions and types in this library, I have had to rely on the use of Macros to generate functions and structs of varying arity. If I had not done this, and had instead opted to use `any Parser` fields for the parse combinators, the performance would have tanked. A side-effect of these macro-generated types however is that the parser combinators currently have a limit for how many parsers they can contain. Right now this is 10 children per parser.

> While this limit might increase based on user feedback (it only involves changing a few numbers), I think most people won’t exceed it because—well, if you reach this limit you’ll probably want refactor some parts of your parser into smaller subparsers to keep them more legible. 

Another big contributor to the performance of this parser is the liberal use of `@inlinable` and `@usableFromInline` to enable the compiler to easily inline any functions it wishes to. In addition I used `structs` instead of `classes` so as to make sure that all method calls are executed statically where possible and there is no dynamic dispatch.

It should also be noted that a lot of optimisations that could make a big difference are not easily available to parser combinators. I’m thinking here, for example of a `[ (a b) / a ]` parser. This could be rewritten to an `[ a [ b ] ]` parser if done properly but such optimisations of the parsing tree are not available when composing functions as these have minimal knowledge of the semantics of the parsing types.
