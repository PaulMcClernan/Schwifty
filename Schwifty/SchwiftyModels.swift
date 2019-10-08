//
//  CodeModels.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

// MARK: - Error
// TODO: Add more detailed error type for debugging
struct ErrorSchwifty: Codable {
    var type = ""
    var pos = 0
    var length = 0
}

// MARK: State
// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
class SchwiftyState: Codable {
    var errors: [ErrorSchwifty] = []
    var lines: [Line] = []
    var variables: [Variable] = []
    
}

// MARK: Line
// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
class Line: Codable {
    var text =  ""
    var pos: Int = -1
    var words: [Word] = [] {
        didSet {
//            print(self.words.last!.variable!.string, ("    :"), self.words.last!.variable!.typeDescription())
        }
    }
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
    
    var value: Variable? = nil
    
    var type = Types.ErrorType
    
    func typeDescription() -> String{
        var typeString = "Undescribed"
        
        if (self.type == .CommandsType) {
            typeString = command!.rawValue
            return typeString
            
        }
        
        if (self.type == .OperatorType) {
            typeString = self.theOperator!.rawValue
            return typeString
            
        }
        
        if (self.value != nil) {
            if (self.value!.isValue()) {
                typeString = self.value!.string
            }
        }
        else {
            typeString = self.type.rawValue
        }
        
        return typeString
    }
    
    enum CodingKeys: CodingKey {
        case name
        case string
    }
    
    init(newVariable: String, varName: String) {
        string = newVariable
        name = varName
        
        assingType()
        
        if type == .ErrorType {
            
        }
    }
    
    func ContainsValidQoute(string: String) -> Bool {
        if string == "\"" || string == "\u{201C}" || string == "\u{201D}" {
            return true
        }
        return false
    }
    
    func isString() -> Bool {
        var isString = false
        
        if ContainsValidQoute(string: String(string.prefix(1))) && ContainsValidQoute(string: String(string.suffix(1))) {
            type = .StringType
            isString = true
        } else if ContainsValidQoute(string: String(string.prefix(1))) && !ContainsValidQoute(string: String(string.suffix(1))) {
            type = .ErrorType
            isString = true
        } else if !ContainsValidQoute(string: String(string.prefix(1))) && ContainsValidQoute(string: String(string.suffix(1))) {
            type = .ErrorType
            isString = true
        }
        
        return isString
    }
    
    func assingType() {
        for (_,theCommand) in Commands.allCases.enumerated() {
            let stringComponents = string.components(separatedBy: theCommand.rawValue)
            if stringComponents.count > 1 {
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
            
            if isString() {return}
            
            type = .VarType
            return
        }
        
        number = assignedNumber!
        
        if type == .LineNumberType {
            return
        }
        
        let numberType = CFNumberGetType(number)
        
        switch numberType {
        case .charType:
            type = .BoolType
        //Bool
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
            type = .IntType
        //Int
        case .doubleType:
            type = .DoubleType
        //Double
        case .float32Type, .float64Type, .floatType, .cgFloatType:
            type = .FloatType
        //Float
        default:
            type = .ErrorType
        }
        
    }
    
    func isValue() -> Bool {
        if self.value != nil {
            return self.value!.type.isValue()
        }
        return false
    }
    
    func description() -> String{
        if self.value != nil {
            var newString = ""
            newString = "\(self.string) = \(self.value!.string)"
            return newString
        }
        return "I have no value"
    }
    
    
}

enum Types: String {
    case ErrorType
    
    case LineNumberType
    
    case CommandsType
    case OperatorType
    case VarType
    
    case StringType
    case IntType
    case DoubleType
    case FloatType
    case BoolType
    
    func isValue() -> Bool {
        switch self {
        case .StringType, .IntType, .DoubleType, .FloatType, .BoolType:
            return true
        default:
            return false
        }
    }
    func isNumber() -> Bool {
        switch self {
        case .IntType, .DoubleType, .FloatType, .BoolType:
            return true
        default:
            return false
        }
    }
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
    func isCreateVariable() -> Bool {
        switch self {
        case .letOp, .varOp:
            return true
        default:
            return false
        }
    }
    
    case assignOp = "="
    case additionAssignOp = "+="
    case subAssignOp = "-="
    func isAssignOperator() -> Bool {
        switch self {
        case .assignOp, .additionAssignOp, .subAssignOp:
            return true
        default:
            return false
        }
    }
    
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
    
    case leftCrotchet = "["
    case rightCrotchet = "]"
    
    case ifOp = "if"
}

let defaultInput = """
var a = 5
let b = 1
let c = a + b
let d = false
let e = -3.14
let f = 5.0
let g = -a
let h = "House"
let i = "ion"
let j = "jet
let k = "redKite

if a = 5 {
a = b + a
}

f += 1
b = b + 1

print(a)


print(c)

a += a

print(a)

"""
