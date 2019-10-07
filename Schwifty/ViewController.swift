//
//  ViewController.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Cocoa

let schwifty = SchwiftEngine()

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
    
    func update(string: String?) {
        log(text: string ?? "nil")
    }

    func log(text: String) {
        outPutField.stringValue = text + "\r" + outPutField.stringValue
    }

}

