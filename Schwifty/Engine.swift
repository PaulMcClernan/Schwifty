//
//  Engine.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

class SchwiftEngine {
    var delegate: SchwiftyDelegate? = nil
    var code : SymbolTable? = nil
    var state = StateSchwifty()
    var rawString: String? = "" {
        didSet {
            if var codeString = rawString {
                if codeString.isEmpty {return}
                
                ///Begin analyzing string from input
                state.errors = []
                state.code.rawCodeString = codeString
                state.code.lines = []
                processLines(codeString: codeString)
                
                delegate?.update(string: codeString)
                print(state.code)
            }
            
            
        }
    }
    
    func processLines(codeString: String) {
        let codeLines = codeString.components(separatedBy: .newlines)
        for (int, lineString) in codeLines.enumerated() {
            let line = Line(text: lineString, pos: int, words: [], theOperator: nil)
            
            processLine(theLine: line)
            //            print("L\(int): " + line)
        }
        
    }
    
    func processLine(theLine: Line) {
        var line: Line = theLine
        
        let codeWords = line.text.components(separatedBy: .whitespaces)
        if codeWords.count == 0 {return}
        if codeWords.count < 3 {return}
        
        if let prefixOperator = Operators.init(rawValue: codeWords[0]) {
            switch prefixOperator {
            case .letOp, .varOp:
                print(prefixOperator)
                createVariable(theLine: line, codeWords: codeWords, operator: prefixOperator)
            case .assignOp:
                print("=")
            default:
                break
            }
            
            
        }
        
   }
    
    func createVariable(theLine: Line,codeWords:[String], operator:Operators) {
        
        
        
    }
    
    
    
}

protocol SchwiftyDelegate {
    func update(string: String?)
    
}
