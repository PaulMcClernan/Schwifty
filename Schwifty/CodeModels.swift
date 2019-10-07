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
    var string =  ""
    var pos = 0
    var length = 0
    
    var command: Commands? = nil
    var theOperator: Operators? = nil
    var variable: Variable? = nil
    
    init(string: String) {
        self.string = string
        
        for (_,theCommand) in Commands.allCases.enumerated() {
            if string == theCommand.rawValue {
                command = theCommand
            }
        }
        for (_,anOpertator) in Operators.allCases.enumerated() {
            if string == anOpertator.rawValue {
                theOperator = anOpertator
            }
        }
        
        if theOperator == nil {
            variable = Variable(newVariable: string, varName: string)
        }
        
    }
    
    
}

class Variable {
    var name = ""
    var type = Types.errorType
    var string: String? = nil
    var number: NSNumber? = nil
    
    init(newVariable: String, varName: String) {
        string = newVariable
        name = varName
        
        assingType()
    }
    
    func assingType() {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        let assignedNumber = formatter.number(from: string!)
        
        if assignedNumber == nil {
            type = Types.StringType
            print("STRING \(string!)")
            
            if string == "false" {
                number = NSNumber(value: false)
                type = Types.BoolType
                print("BOOL \(String(describing: number))")
            }
            else if string == "true" {
                number = NSNumber(value: true)
                type = Types.BoolType
                print("BOOL \(String(describing: number))")
            }
            
            return
        }
        
        let numberType = CFNumberGetType(assignedNumber)
        
        switch numberType {
        case .charType:
            number = NSNumber(value: assignedNumber!.boolValue)
            type = Types.BoolType
            print("CHAR \(String(describing: number))")
        //Bool
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
            number = NSNumber(value: assignedNumber!.intValue)
            type = Types.IntType
            print("INT \(String(describing: assignedNumber))")
        //Int
        case .doubleType:
            number = NSNumber(value: assignedNumber!.doubleValue)
            type = Types.doubleType
            print("DOUBLE \(String(describing: assignedNumber))")
        //Double
        case .float32Type, .float64Type, .floatType, .cgFloatType:
            number = NSNumber(value: assignedNumber!.floatValue)
            type = Types.FloatType
            print("FLOAT \(String(describing: assignedNumber))")
        //Float
        default:
            type = Types.errorType
            print("numberERROR")
            return
        }
    }
}

enum Types: String {
    case errorType
    case CommandsType
    case OperatorType
    case StringType
    case IntType
    case doubleType
    case FloatType
    case BoolType
}

enum Commands: String, CaseIterable {
    case Dev = "Dev"
    case UI = "UI"
}

enum Operators: String, CaseIterable {
    case letOp = "let"
    case varOp = "var"
    
    case assignOp = "="
    case additionAssignOp = "+="
    case subAssignOp = "-="
    
    case addOp = "+"
    case subOp = "-"
    case multOp = "*"
    case divOp = "/"
    
    case remainderOp = "%"
    
    case equalsOp = "=="
    case notOp = "!="
    
    case greaterOp = ">"
    case lessop = "<"
    case greaterEqualOp = ">="
    case lessEqualop = "<="
    
    case leftParentheses = "("
    case rightParentheses = ")"
    
    case leftBracket = "{"
    case rightBracket = "}"
    
    case ifOp = "if"
}

let defaultInput = """
var a = 5
let b = 1

if a = 5 {
a = b + a
}

print(a)

let c = a + b

print(c)

let d = false
let e = -3.14
let f = 5.0
let g = -a

a += a

print(a)


"""
