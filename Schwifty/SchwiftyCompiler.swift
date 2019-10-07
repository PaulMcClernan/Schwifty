//
//  Engine.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

class SchwiftyCompiler: Codable {
    var delegate: SchwiftyDelegate? = nil
    var state = SchwiftyState()
    var rawString: String? = "" {
        didSet {
            if let codeString = rawString {
                if codeString.isEmpty {return}
                
                ///Begin analyzing string from input
                state.errors = []
                state.table = SymbolTable(lines: [])
                interpretLines(codeString: codeString)
                
                syntaxHighlighter = SchwiftyHighlighter(compiler: self)
                
                delegate?.update()
                
            }
        }
    }
    var syntaxHighlighter: SchwiftyHighlighter? = nil
    var attributedString: NSAttributedString? = nil
    
    enum CodingKeys: CodingKey {
        case state
        case rawString
    }
    
    func interpretLines(codeString: String) {
        let codeLines = codeString.components(separatedBy: .newlines)
        for (int, lineString) in codeLines.enumerated() {
            let line = Line(text: lineString, pos: int, words: [], theOperator: nil)
            
            interpretLine(theLine: line)
            state.table.lines.append(line)
        }
        
    }
    
    func interpretLine(theLine: Line) {
        let line: Line = theLine
        
        let codeWords = line.text.components(separatedBy: .whitespaces)
        if codeWords.count == 0 {return}
        if codeWords.count < 3 {return}
        
        for (_,word) in codeWords.enumerated() {
            let newWord = Word(string: word)
            line.words.append(newWord)
            self.state.table.variables.append(newWord.variable!)
        }
    }    
    
}

protocol SchwiftyDelegate {
    func update()
}
