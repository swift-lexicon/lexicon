//
//  Repeat.swift
//  Lexicon
//
//  Created by Aaron Vranken on 27/01/2025.
//


public struct Repeat<RepeatParser: Parser>: Parser {
    @usableFromInline let parser: RepeatParser
    
    @inlinable init<P: Parser>(
        lowerBound: Int = 0,
        upperBound: Int?,
        parser: P
    )
    where RepeatParser == RepeatParsers.RepeatBasic<P>
    {
        self.parser = RepeatParsers.RepeatBasic(
            parser: parser,
            lowerBound: lowerBound,
            upperBound: upperBound
        )
    }
    
    @inlinable init<P: Parser, Separator: Parser>(
        lowerBound: Int = 0,
        upperBound: Int?,
        parser: P,
        separator: Separator
    )
    where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator>
    {
        self.parser = RepeatParsers.RepeatSeparator(
            parser: parser,
            separator: separator,
            lowerBound: lowerBound,
            upperBound: upperBound
        )
    }
    
    @inlinable init<P: Parser, Until: Parser>(
        lowerBound: Int = 0,
        upperBound: Int?,
        parser: P,
        until: Until
    )
    where RepeatParser == RepeatParsers.RepeatUntil<P, Until>
    {
        self.parser = RepeatParsers.RepeatUntil(
            parser: parser,
            until: until,
            lowerBound: lowerBound,
            upperBound: upperBound
        )
    }
    
    @inlinable
    public func parse(_ input: RepeatParser.Input) throws -> ParseResult<RepeatParser.Output, RepeatParser.Input>? {
        try parser.parse(input)
    }
}

public extension Repeat {
    @inlinable
    init<P: Parser>(
        between: ClosedRange<Int>,
        parser: P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: between.upperBound,
            parser: parser
        )
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        between: ClosedRange<Int>,
        parser: P,
        separator: Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: between.upperBound,
            parser: parser,
            separator: separator
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        between: ClosedRange<Int>,
        parser: P,
        until: Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: between.upperBound,
            parser: parser,
            until: until
        )
    }
    
    @inlinable
    init<P: Parser>(
        between: ClosedRange<Int>,
        @ParseBuilder _ builder: () -> P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(between: between, parser: builder())
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        between: ClosedRange<Int>,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder separator: () -> Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            between: between,
            parser: builder(),
            separator: separator()
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        between: ClosedRange<Int>,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder until: () -> Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            between: between,
            parser: builder(),
            until: until()
        )
    }
}

public extension Repeat {
    @inlinable
    init<P: Parser>(
        between: PartialRangeThrough<Int>,
        parser: P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(
            upperBound: between.upperBound,
            parser: parser
        )
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        between: PartialRangeThrough<Int>,
        parser: P,
        separator: Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            upperBound: between.upperBound,
            parser: parser,
            separator: separator
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        between: PartialRangeThrough<Int>,
        parser: P,
        until: Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            upperBound: between.upperBound,
            parser: parser,
            until: until
        )
    }
    
    @inlinable
    init<P: Parser>(
        between: PartialRangeThrough<Int>,
        @ParseBuilder _ builder: () -> P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(between: between, parser: builder())
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        between: PartialRangeThrough<Int>,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder separator: () -> Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            between: between,
            parser: builder(),
            separator: separator()
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        between: PartialRangeThrough<Int>,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder until: () -> Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            between: between,
            parser: builder(),
            until: until()
        )
    }
}

public extension Repeat {
    @inlinable
    init<P: Parser>(
        between: PartialRangeFrom<Int>,
        parser: P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: nil,
            parser: parser
        )
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        between: PartialRangeFrom<Int>,
        parser: P,
        separator: Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: nil,
            parser: parser,
            separator: separator
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        between: PartialRangeFrom<Int>,
        parser: P,
        until: Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            lowerBound: between.lowerBound,
            upperBound: nil,
            parser: parser,
            until: until
        )
    }
    
    @inlinable
    init<P: Parser>(
        between: PartialRangeFrom<Int>,
        @ParseBuilder _ builder: () -> P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(between: between, parser: builder())
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        between: PartialRangeFrom<Int>,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder separator: () -> Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            between: between,
            parser: builder(),
            separator: separator()
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        between: PartialRangeFrom<Int>,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder until: () -> Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            between: between,
            parser: builder(),
            until: until()
        )
    }
}

public extension Repeat {
    @inlinable
    init<P: Parser>(times: Int, parser: P)
    where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(
            between: times...times,
            parser: parser
        )
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(times: Int, parser: P, separator: Separator)
    where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            between: times...times,
            parser: parser,
            separator: separator
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(times: Int, parser: P, until: Until)
    where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            between: times...times,
            parser: parser,
            until: until
        )
    }
    
    
    @inlinable
    init<P: Parser>(
        times: Int,
        @ParseBuilder _ builder: () -> P
    ) where RepeatParser == RepeatParsers.RepeatBasic<P> {
        self.init(
            times: times,
            parser: builder()
        )
    }
    
    @inlinable
    init<P: Parser, Separator: Parser>(
        times: Int,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder _ separator: () -> Separator
    ) where RepeatParser == RepeatParsers.RepeatSeparator<P, Separator> {
        self.init(
            times: times,
            parser: builder(),
            separator: separator()
        )
    }
    
    @inlinable
    init<P: Parser, Until: Parser>(
        times: Int,
        @ParseBuilder _ builder: () -> P,
        @ParserBuilder _ until: () -> Until
    ) where RepeatParser == RepeatParsers.RepeatUntil<P, Until> {
        self.init(
            times: times,
            parser: builder(),
            until: until()
        )
    }
}

extension Parser {
    @inlinable
    public func repeating(times: Int) -> Repeat<
        RepeatParsers.RepeatBasic<Self>
    > {
        return Repeat(times: times, parser: self)
    }
    
    @inlinable
    public func repeating(between: ClosedRange<Int>) -> Repeat<
        RepeatParsers.RepeatBasic<Self>
    > {
        return Repeat(between: between, parser: self)
    }
    
    @inlinable
    public func repeating(between: PartialRangeFrom<Int>) -> Repeat<
        RepeatParsers.RepeatBasic<Self>
    > {
        return Repeat(between: between, parser: self)
    }
    
    @inlinable
    public func repeating(between: PartialRangeThrough<Int>) -> Repeat<
        RepeatParsers.RepeatBasic<Self>
    > {
        return Repeat(between: between, parser: self)
    }
}

extension Repeat: Sendable where RepeatParser: Sendable {}

public enum RepeatParsers {}

public extension RepeatParsers {
    struct RepeatBasic<P: Parser>: Parser {
        @usableFromInline let parser: P
        @usableFromInline let lowerBound: Int
        @usableFromInline let upperBound: Int?
        
        @inlinable init(parser: P, lowerBound: Int = 0, upperBound: Int?) {
            assert(lowerBound >= 0)
            
            self.lowerBound = lowerBound
            self.upperBound = upperBound
            self.parser = parser
        }
        
        @inlinable
        public func parse(
            _ input: P.Input
        ) throws -> ParseResult<[P.Output], P.Input>? {
            var results: [P.Output] = []
            var remaining = input
            
            var i = 0
            while
                upperBound.map({ i < $0 }) ?? true,
                let result = try parser.parse(remaining)
            {
                results.append(result.output)
                remaining = result.remaining
                i += 1
            }
            
            guard i >= lowerBound else {
                return nil
            }
            
            return ParseResult(results, remaining)
        }
    }
}

extension RepeatParsers.RepeatBasic: Sendable where P: Sendable {}

public extension RepeatParsers {
    struct RepeatSeparator<P: Parser, Separator: Parser>: Parser
    where P.Input == Separator.Input {
        @usableFromInline let parser: P
        @usableFromInline let separator: Separator
        @usableFromInline let lowerBound: Int
        @usableFromInline let upperBound: Int?
        
        @inlinable init(
            parser: P,
            separator: Separator,
            lowerBound: Int = 0,
            upperBound: Int?
        ) {
            assert(lowerBound >= 0)
            
            self.lowerBound = lowerBound
            self.upperBound = upperBound
            self.parser = parser
            self.separator = separator
        }
        
        @inlinable
        public func parse(_ input: P.Input) throws -> ParseResult<[P.Output], P.Input>? {
            var results: [P.Output] = []
            var remaining = input
            
            var separatorMatch = true
            
            var i = 0
            while
                upperBound.map({ i < $0 }) ?? true,
                separatorMatch,
                let result = try parser.parse(remaining)
            {
                results.append(result.output)
                remaining = result.remaining
                
                if let separatorResult = try separator.parse(remaining) {
                    remaining = separatorResult.remaining
                } else {
                    separatorMatch = false
                }
                    
                i += 1
            }
            
            guard i >= lowerBound else {
                return nil
            }
            
            return ParseResult(results, remaining)
        }
    }
}

extension RepeatParsers.RepeatSeparator: Sendable
where P: Sendable, Separator: Sendable {}

public extension RepeatParsers {
    struct RepeatUntil<P: Parser, Until: Parser>: Parser
    where P.Input == Until.Input {
        @usableFromInline let parser: P
        @usableFromInline let until: Until
        @usableFromInline let lowerBound: Int
        @usableFromInline let upperBound: Int?
        
        @inlinable init(
            parser: P,
            until: Until,
            lowerBound: Int = 0,
            upperBound: Int?
        ) {
            assert(lowerBound >= 0)
            
            self.lowerBound = lowerBound
            self.upperBound = upperBound
            self.parser = parser
            self.until = until
        }
        
        @inlinable
        public func parse(_ input: P.Input) throws -> ParseResult<[P.Output], P.Input>? {
            var results: [P.Output] = []
            var remaining = input
            
            var untilResult = try until.parse(remaining)
            
            var i = 0
            while
                upperBound.map({ i < $0 }) ?? true,
                untilResult == nil,
                let result = try parser.parse(remaining)
            {
                results.append(result.output)
                remaining = result.remaining
                
                untilResult = try until.parse(remaining)
                
                i += 1
            }
            
            if let untilResult {
                remaining = untilResult.remaining
            }
            
            guard i >= lowerBound else {
                return nil
            }
            
            return ParseResult(results, remaining)
        }
    }
}

extension RepeatParsers.RepeatUntil: Sendable
where P: Sendable, Until: Sendable {}
