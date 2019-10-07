//
//  CodeModels.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

struct ErrorSchwifty: Codable {
    var type = ""
    var pos = 0
    var length = 0
}

class SchwiftyState: Codable {
    var errors: [ErrorSchwifty] = []
    var table: SymbolTable = SymbolTable(lines: [])
}

class SymbolTable: Codable {
    
    var lines: [Line] = []
    var variables: [Variable] = []
    
    init(lines: [Line]) {
        self.lines = lines
    }
}

class Line: Codable {
    var text =  ""
    var pos = 0
    var words: [Word] = []
    var theOperator: Operators? = nil
    
    enum CodingKeys: CodingKey {
        case text
        case words
    }
    
    init(text: String, pos: Int, words: [Word], theOperator: Operators?) {
        self.text = text
        self.pos = pos
        self.words = words
        self.theOperator = theOperator
    }
}

class Word: Codable {
    var string =  ""
    var pos = 0
    var length = 0
    
    var variable: Variable? = nil
    
    enum CodingKeys: CodingKey {
        case string
        case variable
    }
    
    init(string: String) {
        self.string = string
        
        variable = Variable(newVariable: string, varName: string)
        
    }
}

class Variable: Codable {
    var name = ""
    
    var string: String = ""
    var number: NSNumber? = nil
    var command: Commands? = nil
    var theOperator: Operators? = nil
    
    var type = Types.errorType
    
    enum CodingKeys: CodingKey {
        case name
        case string
    }
    
    init(newVariable: String, varName: String) {
        string = newVariable
        name = varName
        
        assingType()
        
        if type == .errorType {
            
        }
    }
    
    func assingType() {
        for (_,theCommand) in Commands.allCases.enumerated() {
            if string == theCommand.rawValue {
                command = theCommand
                type = .CommandsType
                return
            }
        }
        for (_,anOpertator) in Operators.allCases.enumerated() {
            if string == anOpertator.rawValue {
                theOperator = anOpertator
                type = .OperatorType
                return
            }
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        let assignedNumber = formatter.number(from: string)
        
        if assignedNumber == nil {
            if string == "false" {
                number = NSNumber(value: false)
                type = .BoolType
                return
            }
            else if string == "true" {
                number = NSNumber(value: true)
                type = .BoolType
                return
            }
            
            if (string.hasPrefix("\"") && string.hasSuffix("\"")) {
                type = .StringType
                return
            } else if ( (string.hasPrefix("\"")) && !(string.hasSuffix("\"")) ) {
                type = .errorType
                return
            } else if ( !(string.hasPrefix("\"")) && (string.hasSuffix("\"")) ) {
                type = .errorType
                return
            }
            
            type = .varType
            return
        }
        
        number = assignedNumber!
        let numberType = CFNumberGetType(number)
        
        switch numberType {
        case .charType:
            type = .BoolType
        //Bool
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
            type = .IntType
        //Int
        case .doubleType:
            type = .doubleType
        //Double
        case .float32Type, .float64Type, .floatType, .cgFloatType:
            type = .FloatType
        //Float
        default:
            type = .errorType
        }
        
        //        print("WORDTYPE: \(type.rawValue)")
    }
}

enum Types: String {
    case errorType
    case CommandsType
    case OperatorType
    case varType
    case StringType
    case IntType
    case doubleType
    case FloatType
    case BoolType
}

enum Commands: String, CaseIterable {
    case Unassigned = "Unassigned"
    case Print = "print"
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
let h = "House"
let i = "ion"
let j = "jet
let k = "redKite

a += a

print(a)


"""