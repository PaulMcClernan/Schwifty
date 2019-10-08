//
//  ViewController.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Cocoa

let schwifty = SchwiftyCompiler()

class ViewController: NSViewController, SchwiftyDelegate, NSTextViewDelegate {
    
    @IBOutlet weak var inPutField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        schwifty.delegate = self
        inPutField.delegate = self
        schwifty.rawString = defaultInput
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    

    func textDidChange(_ notification: Notification) {
        if let field = notification.object as? NSTextView {
        schwifty.rawString = field.string
        }
    }
    
    func update() {
        if schwifty.attributedString != nil {
            let m = inPutField.selectedRanges
            inPutField.textStorage?.setAttributedString(schwifty.attributedString!)
            inPutField.selectedRanges = m
        } else {
            inPutField.string = schwifty.rawString ?? "no code"
        }
    }
    
}

