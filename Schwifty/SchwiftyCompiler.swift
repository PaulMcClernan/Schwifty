//
//  Engine.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

let schwifty = SchwiftyCompiler(highlightSyntax: true, string: nil)

class SchwiftyCompiler: Codable {
    // MARK: - Basics
    var delegate: SchwiftyDelegate? = nil
    var state = SchwiftyState()
    
    // MARK: Syntax Highlighting
    var highlightSyntax = false
    var syntaxHighlighter: SchwiftyHighlighter? = nil
    var attributedString: NSAttributedString? = nil
    
    // MARK: - rawString
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
    // TODO: Add support for creating a light compiler for a highlighter
    /*
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
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
    
    // MARK: - Interpreter - Line
    //Splits the raw code string into string components based on newlines.
    func interpretLines(codeString: String) {
        print("\r\t Interpreted Lines\r")
        
        let codeLines = codeString.components(separatedBy: .newlines)
        
        for (int, lineString) in codeLines.enumerated() {
            
            let line = Line(text: lineString, pos: int, words: [], theOperator: nil)
            
            // MARK: Interpreter - Word
            //Splits the line String into string components based on whitespace.
            let codeWords = line.string.components(separatedBy: .whitespaces)
            for (_,word) in codeWords.enumerated() {
                
                //Creates a new word and adds its variable to the state.
                let newWord = Word(string: word)
                line.words.append(newWord)
            }
            
            state.lines.append(line)
            
            // MARK: - *End of Compiler Light*
            // Past here lies any code that should be used for scripting.
            
            // MARK: - Line Pattern
            //patterns
            if line.words.count > 3 {
                let lineNumber = line.pos
                
                
                // MARK: Create new variable
                let variable1 = line.words[0] /// likely let/var or var ie "Let " or "foo "
                let variable2 = line.words[1] /// likely var or assignOp ie "foo " or "= "
                let variable3 = line.words[3] /// likely var ie "foo " or "\"foo\"" | "3.14" | "false"
                
                if (variable1.theOperator?.isCreateVariable() ?? false) {
                    
                    // Unknown type or error
                    if !(variable3.type.isValue()) {
                        variable3.type = .ErrorType
                        //Adds whole line error
//                        line.hasError = true
                        print("L:\(lineNumber): \(variable3.string) : Not a supported value")
                        continue
                    }
                    
                    // var found
                    variable2.value = variable3
                    state.variables.append(variable2)
                    print(("L:\(lineNumber): "), variable2.description())
                    continue
                }
                
                // Modify existing variable
                if variable2.theOperator?.isAssignOperator() ?? false {
                    if state.hasVariable(variable: variable1) {print("L:\(lineNumber): \(variable1.string) \(variable2.theOperator!.string())  : I have already been assigned")
                    }
                }
                
            }
            
            //Adds line to state
            
        }
        
        print("\r\t Assigned Vars\r")
        for (_,stateVariable) in state.variables.enumerated() {
            print(stateVariable.string, (": "), stateVariable.value!.string, (": "), stateVariable.value!.typeDescription())
        }
    }
    
}

// MARK: - Delegate
//Splits the raw code string into string components based on newlines.
protocol SchwiftyDelegate {
    func update()
}
