//
//  SchwiftyHighlighter.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 10/7/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation
import Cocoa

class SchwiftyHighlighter: Codable {
    var compiler: SchwiftyCompiler
    var attributedString: NSAttributedString? = nil
    
    enum CodingKeys: CodingKey {
        case compiler
    }
    
    // MARK: Init
    // TODO: Add support for creating a highlighter without a compiler.
    /*
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
    init(compiler: SchwiftyCompiler, rawString: String) {
        self.compiler = compiler
        self.attributedString = NSAttributedString(string: rawString)
        //        let encoder = JSONEncoder()
        //        do {
        //            let jsonData = try encoder.encode(compiler)
        //            let jsonString = String(data: jsonData, encoding: .utf8)
        //            print(jsonString ?? "EncoderError")
        //        } catch {
        //            print("EncodingError: \(error)")
        //        }
        
        let newAttributed = NSMutableAttributedString(string: "")
        
        
        for (_,line) in compiler.state.lines.enumerated() {
            for (i,word) in line.words.enumerated() {
                newAttributed.append(AttributesForVariable(variable: word))
                if i != line.words.count - 1 {
                    newAttributed.append(NSAttributedString(string: " "))
                }
            }
            newAttributed.append(NSAttributedString(string: "\r"))
        }
        
        self.attributedString = newAttributed
        
    }
    
    /*For Ref
     enum Types: String {
     case errorType
     case LineNumber
     case CommandsType
     case OperatorType
     case varType
     case StringType
     case IntType
     case doubleType
     case FloatType
     case BoolType
     }
     */
    
    let kDefaultFontSize: CGFloat = 15.0
    let kDefaultFontSizeSmall: CGFloat = 11.0
    
    private func AssignOperatorAttributes(_ variable: Word, _ multipleAttributes: inout [NSAttributedString.Key : Any]) {
        var font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .medium)
        multipleAttributes[NSAttributedString.Key.font] = font
        
        switch variable.theOperator {
        case .letOp, .varOp, .ifOp:
            let font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .semibold)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemPink
            return
        default:
            font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .regular)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemPurple
        }
        
    }
    
    func AttributesForVariable(variable: Word) -> NSAttributedString {
        var multipleAttributes = [NSAttributedString.Key : Any]()
        
        var font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .medium)
        
        multipleAttributes[NSAttributedString.Key.font] = font
        multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
        
        switch variable.type {
        case .ErrorType:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .regular)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemRed
            multipleAttributes[NSAttributedString.Key.backgroundColor] = NSColor(calibratedHue: 0.0, saturation: 1.0, brightness: 0.0, alpha: 0.25)
        case .LineNumberType:
            font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .light)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemGray
        case .CommandsType:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemGreen
        case .OperatorType:
            AssignOperatorAttributes(variable, &multipleAttributes)
        case .VarType:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .light)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemTeal
        case .StringType:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
        case .IntType, .DoubleType, .FloatType:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .regular)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemYellow
        case .BoolType:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .semibold)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemPink
        }
        
        let myAttrString = NSAttributedString(string: variable.string, attributes: multipleAttributes)
        return myAttrString
        
    }
}


