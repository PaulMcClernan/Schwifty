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
    
    @IBOutlet weak var outPutField: NSTextField!
    @IBOutlet weak var inPutField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schwifty.delegate = self
        inPutField.string = defaultInput
        inPutField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func inputUpdate(_ sender: Any) {
        schwifty.rawString = inPutField.string
    }
    func textDidChange(_ notification: Notification) {
        schwifty.rawString = inPutField.string
    }
    
    func update() {
//        outPutField.stringValue = schwifty.rawString ?? "¡ERROR!"
        
        if schwifty.attributedString != nil {
            print("attributedString")
//            let m = inPutField.selectedRanges
//            inPutField.textStorage?.setAttributedString(schwifty.attributedString!)
//            inPutField.selectedRanges = m
            outPutField.attributedStringValue = schwifty.attributedString!
        }
    }
    
}

