//
//  ViewController.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Cocoa
import SwiftScriptCompiler

class ViewController: NSViewController, SchwiftScriptDelegate, NSTextViewDelegate {
    
    @IBOutlet weak var inPutField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SwiftScriptCompiler.compiler.delegate = self
        inPutField.delegate = self
        SwiftScriptCompiler.compiler.string = defaultInput
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func textDidChange(_ notification: Notification) {
        if let field = notification.object as? NSTextView {
            SwiftScriptCompiler.compiler.string = field.string
        }
    }
    
    func update() {
        if SwiftScriptCompiler.compiler.attributedString != nil {
            let selectedRanges = inPutField.selectedRanges
            inPutField.textStorage?.setAttributedString(SwiftScriptCompiler.compiler.attributedString!)
            inPutField.selectedRanges = selectedRanges
        } else {
            inPutField.string = SwiftScriptCompiler.compiler.string ?? "no code"
        }
    }
    
}

