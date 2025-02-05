//
//  ParseWithCapturesPrinters.swift
//  lexicon
//
//  Created by Aaron Vranken on 03/02/2025.
//

import Foundation

extension ParseBuilder.FinalWithCaptures: Printer
where P: Printer {
    @inlinable
    public func print(_ output: P.Output) throws -> P.Input? {
        try parser.print(output)
    }
}

extension ParseBuilder.CaptureBoth: Printer
where P1: Printer, P2: Printer, P1.Input: Appendable {
    @inlinable
    public func print(_ output: Captures) throws -> P1.Input? {
        let (output1, output2) = separate(output)
        if let input1 = try parser1.print(output1),
           let input2 = try parser2.print(output2) {
            var input = input1
            input.append(contentsOf: input2)
            
            return input
        }
        
        return nil
    }
}

extension ParseBuilder.CaptureFirst: Printer
where P1: Printer, P2: VoidPrinter, P1.Input: Appendable {
    @inlinable
    public func print(_ output: P1.Output) throws -> P1.Input? {
        if let input1 = try parser1.print(output),
           let input2 = try parser2.print() {
            var input = input1
            input.append(contentsOf: input2)
            
            return input
        }
        
        return nil
    }
}

extension ParseBuilder.CaptureSecond: Printer
where P1: VoidPrinter, P2: Printer, P1.Input: Appendable {
    @inlinable
    public func print(_ output: P2.Output) throws -> P2.Input? {
        if let input1 = try parser1.print(),
           let input2 = try parser2.print(output) {
            var input = input1
            input.append(contentsOf: input2)
            
            return input
        }
        
        return nil
    }
}

extension ParseBuilder.DiscardBoth: VoidPrinter
where P1: VoidPrinter, P2: VoidPrinter, P1.Input: Appendable {
    @inlinable
    public func print() throws -> P2.Input? {
        if let input1 = try parser1.print(),
           let input2 = try parser2.print() {
            var input = input1
            input.append(contentsOf: input2)
            
            return input
        }
        
        return nil
    }
}

extension ParseBuilder.BaseWithoutCaptures: VoidPrinter
where P: VoidPrinter {
    @inlinable
    public func print() throws -> P.Input? {
        try parser.print()
    }
}
