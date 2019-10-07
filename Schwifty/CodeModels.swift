//
//  CodeModels.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

class SymbolTable {
    var rawCodeString = ""
    var lines: [String] = []
    
    init(rawCodeString: String, lines: [String]) {
        self.rawCodeString = rawCodeString
        self.lines = lines
    }
}

class Line {
    var text =  ""
    var pos = 0
    var words: [Word] = []
    var theOperator: Operators? = nil
    
    init(text: String, pos: Int, words: [Word], theOperator: Operators?) {
        self.text = text
        self.pos = pos
        self.words = words
        self.theOperator = theOperator
    }
}

class Word {
    var text =  ""
    var pos = 0
    var length = 0
    
    var theOperator: Operators? = nil
    var variable: variable? = nil
}

class variable {
    var name = ""
    var type = VariableType.errorType
    var string: String? = nil
    var int: Int? = Int(Int64.max)
    var float: Float? = nil
    var double: Double? = nil
    var bool: Bool? = nil
    
    init(variable: Any?, varName: String) {
        name = varName
        
        if variable == nil {
            type = VariableType.errorType
            return
        }
        
        switch variable {
        case is String:
            string = variable as? String
        default:
            print(variable ?? "error")
        }
        
    }
}
enum VariableType {
    case errorType
    case StringType
    case IntType
    case doubleType
    case FloatType
    case BoolType
}

enum Operators: String {
    case letOp = "let"
    case varOp = "var"
    case ifOp = "if"
    case addOp = "+"
    case minusOp = "-"
    case multOp = "*"
    case divOp = "/"
    case assignOp = "="
    case equalsOp = "=="
}

let defaultInput = """
var a = 5
let b = 1

if a = 5 {
a = b + a
}

let c = a + b
"""
