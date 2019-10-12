//
//  SchwiftyBlocks.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 10/11/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

// MARK: - Block
// Blocks are where all of the scripting magive happens. If this gets as long as Word, then will have to break out into seperate swift file.

/*
Block Types
 Create:
    Let X   =   1
 Assign
    X   =   2
 Operator
    x   +   3
 
 Swift Infix Operator Precedence: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations#2881142
 PRECEDENCE: * / % + - *= /= += -=
*/

class Block {
    var string: String = Types.ErrorType.rawValue
    var orderedWords: [Int:Word] = [:]
    
   // MARK: init
init(string: String, words: [Word]) {
        orderWords(words)
    }
    
    func orderWords(_ words: [Word]) {
        for (i,word) in words.enumerated() {
            self.orderedWords[i] = word
        }
    }
    
    func interpretBlocks() {
        
    }
    
    
}

// MARK: init
class instruction: Codable {
    var word: Word? = nil
    
}

// MARK: - Types
//
enum BlockCommands {
    case Create
    case Assign
    case OperatorCommand
}
