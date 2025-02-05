//
//  Printer.swift
//  lexicon
//
//  Created by Aaron Vranken on 02/02/2025.
//

public protocol Printer<Input, Output> {
    associatedtype Input
    associatedtype Output
    
    func print(_ output: Output) throws -> Input?
}

public protocol VoidPrinter<Input> {
    associatedtype Input
    
    func print() throws -> Input?
}


public protocol InputPrinter<Input> {
    associatedtype Input
    
    func printWithRemaining(_ output: Input) throws -> InputPrintResult<Input>?
}

public struct InputPrintResult<Input> {
    @usableFromInline let input: Input
    @usableFromInline let remaining: Input
    
    @inlinable
    public init(_ input: Input, _ remaining: Input) {
        self.input = input
        self.remaining = remaining
    }
}
