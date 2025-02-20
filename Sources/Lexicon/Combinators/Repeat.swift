//
//  Repeat.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//

/**
 # Description
 The `Repeat` parser allows you to specify a certain amount of minimum and maximum matches for a parser.
 */
public struct Repeat<P: Parser, Separator: Parser, Until: Parser>: Parser
where P.Input == Separator.Input, Until.Input == P.Input {
    @usableFromInline let minCount: Int
    @usableFromInline let maxCount: Int?
    @usableFromInline let parser: P
    @usableFromInline let separator: Separator?
    @usableFromInline let until: Until?
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        parser: P
    )
    where Separator == NeverParser<P.Input, Void>,
          Until == NeverParser<P.Input, Void>
    {
        self.minCount = min
        self.maxCount = max
        self.parser = parser
        self.separator = nil
        self.until = nil
    }
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        parser: P,
        separator: Separator
    )
    where Until == NeverParser<P.Input, Void>
    {
        self.minCount = min
        self.maxCount = max
        self.parser = parser
        self.separator = separator
        self.until = nil
    }
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        parser: P,
        until: Until
    )
    where Separator == NeverParser<P.Input, Void>
    {
        self.minCount = min
        self.maxCount = max
        self.parser = parser
        self.separator = nil
        self.until = until
    }
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        parser: P,
        separator: Separator?,
        until: Until?
    ) {
        self.minCount = min
        self.maxCount = max
        self.parser = parser
        self.separator = separator
        self.until = until
    }
    
    @inlinable
    public func parse(_ input: P.Input) throws -> ParseResult<[P.Output], P.Input>? {
        var results: [P.Output] = []
        var remaining = input
        var untilReached = until == nil
        
        results.reserveCapacity(minCount)
        
        while results.count < ( maxCount ?? .max ) {
            // Stop parsing the moment you reach an until parser
            if let untilRemaining = try until?.parse(remaining)?.remaining {
                remaining = untilRemaining
                untilReached = true
                break
            }
            
            guard let result = try parser.parse(remaining) else { break }
            results.append(result.output)
            remaining = result.remaining
            
            // Stop parsing the moment the separator fails
            if let separator,
               let separatorRemaining = try separator.parse(remaining)?.remaining {
                remaining = separatorRemaining
            } else if separator != nil {
                break
            }
        }
        
        if !untilReached {
            if let untilRemaining = try until?.parse(remaining)?.remaining {
                remaining = untilRemaining
                untilReached = true
            }
        }
        
        guard results.count >= minCount, untilReached else {
            return nil
        }
        
        return ParseResult(results, remaining)
    }
}

extension Repeat: Sendable
where P: Sendable, Separator: Sendable, Until: Sendable {}

extension Repeat: Printer
where
    P: Printer,
    Separator: VoidPrinter,
    Until: VoidPrinter,
    P.Input: EmptyInitializable,
    P.Input: Appendable
{
    @inlinable
    public func print(
        _ outputs: [P.Output]
    ) throws -> P.Input? {
        guard outputs.count >= minCount,
              maxCount.map({ outputs.count <= $0}) ?? true else {
            return nil
        }
        
        var input = Input.initEmpty()
        
        // Print all normal inputs with separators with separators in between
        for (i, output) in outputs.enumerated() {
            guard let inputElement = try parser.print(output) else {
                return nil
            }
            
            input.append(contentsOf: inputElement)
            
            if let separator,
                i < outputs.count - 1 {
                guard let separatorInput = try separator.print() else {
                    return nil
                }
                input.append(contentsOf: separatorInput)
            }
        }
        
        // If there is an until parser, add another separator and the until input
        if let until {
            if let separator {
                guard let separatorInput = try separator.print() else {
                    return nil
                }
                
                input.append(contentsOf: separatorInput)
            }
            
            guard let untilInput = try until.print() else {
                return nil
            }
            
            input.append(contentsOf: untilInput)
        }
        
        return input
    }
}

public extension Repeat {
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        @ParseBuilder _ builder: () -> P
    )
    where Separator == NeverParser<P.Input, Void>,
          Until == NeverParser<P.Input, Void>
    {
        self.minCount = min
        self.maxCount = max
        self.parser = builder()
        self.separator = nil
        self.until = nil
    }
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        @ParseBuilder _ builder: () -> P,
        @DiscardBuilder separator: () -> Separator
    )
    where Until == NeverParser<P.Input, Void>
    {
        self.minCount = min
        self.maxCount = max
        self.parser = builder()
        self.separator = separator()
        self.until = nil
    }
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        @ParseBuilder _ builder: () -> P,
        @DiscardBuilder until: () -> Until
    )
    where Separator == NeverParser<P.Input, Void>
    {
        self.minCount = min
        self.maxCount = max
        self.parser = builder()
        self.separator = nil
        self.until = until()
    }
    
    @inlinable init(
        min: Int = 0,
        max: Int? = nil,
        @ParseBuilder _ builder: () -> P,
        @DiscardBuilder separator: () -> Separator,
        @DiscardBuilder until: () -> Until
    ) {
        self.minCount = min
        self.maxCount = max
        self.parser = builder()
        self.separator = separator()
        self.until = until()
    }
}

public extension Repeat {
    @inlinable init(
        times: Int,
        @ParseBuilder _ builder: () -> P
    )
    where Separator == NeverParser<P.Input, Void>,
          Until == NeverParser<P.Input, Void>
    {
        self.minCount = times
        self.maxCount = times
        self.parser = builder()
        self.separator = nil
        self.until = nil
    }
    
    @inlinable init(
        times: Int,
        @ParseBuilder _ builder: () -> P,
        @DiscardBuilder separator: () -> Separator
    )
    where Until == NeverParser<P.Input, Void>
    {
        self.minCount = times
        self.maxCount = times
        self.parser = builder()
        self.separator = separator()
        self.until = nil
    }
    
    @inlinable init(
        times: Int,
        @ParseBuilder _ builder: () -> P,
        @DiscardBuilder until: () -> Until
    )
    where Separator == NeverParser<P.Input, Void>
    {
        self.minCount = times
        self.maxCount = times
        self.parser = builder()
        self.separator = nil
        self.until = until()
    }
    
    @inlinable init(
        times: Int,
        @ParseBuilder _ builder: () -> P,
        @DiscardBuilder separator: () -> Separator,
        @DiscardBuilder until: () -> Until
    ) {
        self.minCount = times
        self.maxCount = times
        self.parser = builder()
        self.separator = separator()
        self.until = until()
    }
    
    @inlinable init(
        times: Int,
        parser: P
    )
    where Separator == NeverParser<P.Input, Void>,
          Until == NeverParser<P.Input, Void>
    {
        self.minCount = times
        self.maxCount = times
        self.parser = parser
        self.separator = nil
        self.until = nil
    }
    
    @inlinable init(
        times: Int,
        parser: P,
        separator: Separator
    )
    where Until == NeverParser<P.Input, Void>
    {
        self.minCount = times
        self.maxCount = times
        self.parser = parser
        self.separator = separator
        self.until = nil
    }
    
    @inlinable init(
        times: Int,
        parser: P,
        until: Until
    )
    where Separator == NeverParser<P.Input, Void>
    {
        self.minCount = times
        self.maxCount = times
        self.parser = parser
        self.separator = nil
        self.until = until
    }
    
    @inlinable init(
        times: Int,
        parser: P,
        separator: Separator,
        until: Until
    ) {
        self.minCount = times
        self.maxCount = times
        self.parser = parser
        self.separator = separator
        self.until = until
    }
}

extension ParserConvertible {
    @inlinable
    public func repeating(times: Int) -> Repeat<
        ParserType,
        NeverParser<ParserType.Input, Void>,
        NeverParser<ParserType.Input, Void>
    > {
        return Repeat(times: times, parser: self.asParser)
    }
    
    @inlinable
    public func repeating(min: Int = 0, max: Int? = nil) -> Repeat<
        ParserType,
        NeverParser<ParserType.Input, Void>,
        NeverParser<ParserType.Input, Void>
    > {
        return Repeat(min: min, max: max, parser: self.asParser)
    }
}

public extension Parsers {
    typealias Repeat = Lexicon.Repeat
}
