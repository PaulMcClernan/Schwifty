//
//  SchwiftyState.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 10/1/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

class StateSchwifty {
    struct errorSchwifty {
        var type = ""
        var pos = 0
        var length = 0
    }
    
    var errors: [errorSchwifty] = []
    var code: SymbolTable = SymbolTable(rawCodeString: "", lines: [])
    
}
