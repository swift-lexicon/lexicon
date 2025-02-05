//
//  ParseWithoutCapturesPrinters.swift
//  lexicon
//
//  Created by Aaron Vranken on 03/02/2025.
//

extension ParseBuilder.FinalWithoutCaptures: Printer
where P: InputPrinter {
    @inlinable
    public func print(
        _ output: P.Input
    ) throws -> P.Input? {
        if let result = try parser.printWithRemaining(output),
           result.remaining.isEmpty {
            return result.input
        }
        
        return nil
    }
}

extension ParseBuilder.DiscardBoth: InputPrinter
where P1: InputPrinter, P2: Printer, P1.Input: Appendable {
    @inlinable
    public func printWithRemaining(
        _ output: P1.Input
    ) throws -> InputPrintResult<P1.Input>? {
        if let printResult = try parser1.printWithRemaining(output),
           let parseResult = try parser2.parse(printResult.remaining),
           let input2 = try parser2.print(parseResult.output){
            var input = printResult.input
            input.append(contentsOf: input2)
            
            return InputPrintResult(input, parseResult.remaining)
        }
        
        return nil
    }
}

extension ParseBuilder.BaseWithoutCaptures: InputPrinter
where P: Printer {
    @inlinable
    public func printWithRemaining(
        _ output: P.Input
    ) throws -> InputPrintResult<P.Input>? {
        if let parseResult = try parser.parse(output),
           let printResult = try parser.print(parseResult.output) {
            return InputPrintResult(printResult, parseResult.remaining)
        }
        
        return nil
    }
}
