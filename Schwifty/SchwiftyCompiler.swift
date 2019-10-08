//
//  Engine.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

class SchwiftyCompiler: Codable {
    // MARK: - Basics
    var delegate: SchwiftyDelegate? = nil
    var state = SchwiftyState()
    
    // MARK: Syntax Highlighting
    var highlightSyntax = false
    var syntaxHighlighter: SchwiftyHighlighter? = nil
    var attributedString: NSAttributedString? = nil
    
    // MARK: rawString
    // Set this to start the compiler.
    var rawString: String? = "" {
        didSet {
            if let codeString = rawString {
                if codeString.isEmpty {return}
                
                ///Makes sure everything is clean.
                state.errors = []
                state.lines = []
                state.variables = []
                
                //Intrepreter
                ///Creates [Line]
                interpretLines(codeString: codeString)
                
                ///Syntax Highlighting
                if highlightSyntax {
                    syntaxHighlighter = SchwiftyHighlighter(compiler: self, rawString: codeString)
                    self.attributedString = syntaxHighlighter?.attributedString
                }
                
                //Delegate
                delegate?.update()
            }
        }
    }
    
    // MARK: Init
    init(highlightSyntax: Bool, string: String?) {
        self.highlightSyntax = highlightSyntax
        if string != nil {
            self.rawString = string!
        }
    }
    
    // MARK: Codable Support
    enum CodingKeys: CodingKey {
        case state
        case rawString
    }
    
    // MARK: Interpreter - Line
    //Splits the raw code string into string components based on newlines.
    func interpretLines(codeString: String) {
        let codeLines = codeString.components(separatedBy: .newlines)
        for (int, lineString) in codeLines.enumerated() {
            
            let line = Line(text: lineString, pos: int, words: [], theOperator: nil)
            
            // MARK: Line number
            // TODO: Line number support
            /*
            let lineNumberWord = Word(string: (String(int) + "\t"))
            lineNumberWord.variable?.type = .LineNumberType
            line.words.append(lineNumberWord)
            self.state.variables.append(lineNumberWord.variable!)
            */
            
            print("\r newLine")
            // MARK: Interpreter - Word
            //Splits the line String into string components based on whitespace.
            let codeWords = line.text.components(separatedBy: .whitespaces)
            for (_,word) in codeWords.enumerated() {
                
                //Creates a new word and adds its variable to the state.
                let newWord = Word(string: word)
                line.words.append(newWord)
                self.state.variables.append(newWord.variable!)
            }
            
            // MARK: Line Pattern
            // 
            
            
            //Adds line to state
            state.lines.append(line)
        }
        
    }
    
}

// MARK: - Delegate
//Splits the raw code string into string components based on newlines.
protocol SchwiftyDelegate {
    func update()
}
