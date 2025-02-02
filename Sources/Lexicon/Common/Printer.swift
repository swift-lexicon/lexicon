//
//  Printer.swift
//  lexicon
//
//  Created by Aaron Vranken on 02/02/2025.
//

public enum PrinterError: Error {
    case cannotPrint
}

public struct PrintResult<Input, Output> {
    @usableFromInline let input: Input
    @usableFromInline let remaining: Output
    
    @inlinable
    public init(_ input: Input, _ remaining: Output) {
        self.input = input
        self.remaining = remaining
    }
}

public protocol Printer<Input, Output> {
    associatedtype Input
    associatedtype Output
    
    func print(_ output: Output) throws -> Input?
}

public protocol PrinterWithRemaining: Printer {
    func printWithRemaining(_ output: Output) throws -> PrintResult<Input, Output>?
}

public extension PrinterWithRemaining {
    @inlinable
    func print(_ output: Output) throws -> Input? {
        try printWithRemaining(output)?.input
    }
}
