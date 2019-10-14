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

// MARK: - State
// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
class SchwiftyState: Codable {
    var version = 0.1
    
    var errors: [ErrorSchwifty] = []
    var lines: [Line] = []
    var variables: [Word] = []
    
    func hasVariable(variable: Word) -> Bool {
        
        for (_,existingVariable) in self.variables.enumerated() {
            if (variable.string == existingVariable.string) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK: - Line
// TODO: Reoganize and make this look prettier.
// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
class Line: Codable {
    var string =  ""
    var pos: Int = -1
    
    var hasError = false
    var isEditing = false
    
    var words: [Word] = []
    var block: Block? = nil
    
    var theOperator: Operators? = nil
    
    enum CodingKeys: CodingKey {
        case string
        case pos
        case words
    }
    
    init(text: String, pos: Int, words: [Word], theOperator: Operators?) {
        self.string = text
        self.pos = pos
        self.words = words
        self.theOperator = theOperator
        
        analyzeWords()
        interpretLine()
        
        self.block = Block(words: self.words)
        
    }
    
    // MARK: Analyze - Word
    // Splits the line String into string components based on whitespace.
    func analyzeWords() {
        let codeWords = self.string.components(separatedBy: .whitespaces)
        for (_,word) in codeWords.enumerated() {
            //Creates a new word and adds its variable to the state.
            let newWord = Word(string: word)
            self.words.append(newWord)
        }
    }
    
    func interpretLine() {
        // MARK: - Line Pattern
        // Step 2 - Patterns
        if self.words.count > 3 {
        let lineNumber = self.pos
                        
                        // MARK: Assign values to variable
                        let variable1 = self.words[0] /// likely let/var or var ie "Let " or "foo "
                        let variable2 = self.words[1] /// likely var or assignOp ie "foo " or "= "
                        let variable3 = self.words[3] /// likely var ie "foo " or "\"foo\"" | "3.14" | "false"
                        
                        if (variable1.theOperator?.isCreateVariable() ?? false) {
                            
                            // Unknown type or error
                            if !(variable3.type.isValue()) {
                                variable3.type = .ErrorType
                                //Adds whole line error
        //                        line.hasError = true
                                print("L:\(lineNumber): \(variable3.string):Not a supported value")
                                return
                            }
                            
                            // var found
                            variable2.value = variable3
                                schwifty.state.variables.append(variable2)
                            print("L:\(lineNumber): \(variable2.description())")
                            return
                        }
                        
                        // Modify existing variable
                        if variable2.theOperator?.isAssignOperator() ?? false {
                            if schwifty.state.hasVariable(variable: variable1) {print("L:\(lineNumber): \(variable1.string) \(variable2.theOperator!.string()):I have already been assigned")
                            }
                        }
                        
                    }
    }
}

// MARK: - Word
//
class Word: Codable {
    var name = ""
    var pos = 0
    
    var string: String = ""
    
    var number: NSNumber? = nil
    var command: Commands? = nil
    var theOperator: Operators? = nil
    
    var value: Word? = nil
    
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
    
    func description() -> String{
        if self.value != nil {
            var newString = ""
            newString = "\(self.string) = \(self.value!.string)"
            return newString
        }
        return "I have no value"
    }
    
    enum CodingKeys: CodingKey {
        case name
        case string
        case pos
        case value
    }
    
    init(string: String) {
        self.string = string
        self.name = string
        
        assingType()
        
        if type == .ErrorType {
            
        }
    }
    
    init(newVariable: String, varName: String) {
        self.string = newVariable
        name = varName
        
        assingType()
        
        if type == .ErrorType {
            
        }
    }
    
    func isQoute(string: String) -> Bool {
        let qoutes = CharacterSet(charactersIn: "\"\u{201C}\u{201D}")
        if string.rangeOfCharacter(from: qoutes) != nil {
            return true
        }
        return false
    }
    
    func isString() -> Bool {
        
        if isQoute(string: String(string.prefix(1))) && isQoute(string: String(string.suffix(1))) {
            type = .StringType
            return true
        }
        return false
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
        
        if isString() {return}
        
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
            
            
            type = .VarType
            return
        }
        
        
        if type == .LineNumberType {
            return
        }
        
        self.number = assignedNumber
        
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
    
}

// MARK: - Types
//
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
    //
    //
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
    
    func string() -> String {
        return self.rawValue
    }
    
    //MultiplicationPrecedence
    //Left associative
    case multOp = "*"
    case divOp = "/"
    case remainderOp = "%"
    
    //AdditionPrecedence
    //Left associative
    case addOp = "+"
    case subOp = "-"
    
    //NilCoalescingPrecedence
    //Right associative
    case nilCoalescingOp = "??"
    
    //ComparisonPrecedence
    //None
    case lessop = "<"
    case lessEqualop = "<="
    case greaterOp = ">"
    case greaterEqualOp = ">="
    case equalsOp = "=="
    case notOp = "!="
    
    //LogicalConjunctionPrecedence
    //Left associative
    case andOp = "&&"
    case orOp = "||"
    
    //AssignmentPrecedence
    //Right associative
    case assignOp = "="
    case multAssignOp = "*="
    case divAssignOp = "/="
    case remainderAssignOp = "%="
    case additionAssignOp = "+="
    case subAssignOp = "-="
    func isAssignOperator() -> Bool {
        switch self {
        case .assignOp, .multAssignOp, .divAssignOp, .remainderOp, .additionAssignOp, .subAssignOp:
            return true
        default:
            return false
        }
    }
    
    case leftCrotchet = "["
    case rightCrotchet = "]"
    
    case leftBracket = "{"
    case rightBracket = "}"
    
    case leftParentheses = "("
    case rightParentheses = ")"
    
    case ifOp = "if"
    func isIfBlock() -> Bool {
        switch self {
        case .ifOp:
            return true
        default:
            return false
        }
    }
}

// MARK: - Default Input
// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
let defaultInput = """
var a = 5
let b = 1
let c = a + b
let d = false
let e = -3.14
let f = 5
let g = -a
let h = "House"
let i = "ion"
let j = "jet
let k = "redKite
let l = 01234567891011
let m = 200e500
let n = f
let o = 0

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
