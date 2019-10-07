//
//  SchwiftyHighlighter.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 10/7/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

class SchwiftyHighlighter: Codable {
    var compiler: SchwiftyCompiler
    
    init(compiler: SchwiftyCompiler) {
        self.compiler = compiler
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(compiler)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString ?? "EncoderError")
        } catch {
            print("EncodingError: \(error)")
        }
        
    }
}
