//
//  ParserPrinter.swift
//  lexicon
//
//  Created by Aaron Vranken on 03/02/2025.
//

import Foundation

public protocol ParserPrinter<Input, Output>: Parser & Printer { }

extension ParserPrinter
where Body: ParserPrinter<Input, Output> {
    
    @inlinable
    public func print(_ output: Output) throws -> Input? {
      try body.print(output)
    }
}
