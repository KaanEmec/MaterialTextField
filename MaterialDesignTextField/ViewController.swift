//
//  ViewController.swift
//  MaterialDesignTextField
//
//  Created by Kaan Emeç on 30.03.2015.
//  Copyright (c) 2015 KE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIMaterialTextFieldDelegate {
    
    @IBOutlet weak var nameField: UIMaterialTextField!
    @IBOutlet weak var surnameField: UIMaterialTextField!
    @IBOutlet weak var somenumberField: UIMaterialTextField!
    @IBOutlet weak var somemoretextField: UIMaterialTextField!
    
    var fieldCreatedOnTheFly: UIMaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.materialDelegate = self
        surnameField.materialDelegate = self
        somenumberField.materialDelegate = self
        somemoretextField.materialDelegate = self
        
        let newOrigin:CGPoint = CGPoint(x: somemoretextField.frame.origin.x, y: somemoretextField.frame.origin.y + 75)
        let newCGRect:CGRect = CGRect(origin: newOrigin, size: somemoretextField.frame.size)
        fieldCreatedOnTheFly = UIMaterialTextField(frame: newCGRect)
        fieldCreatedOnTheFly.placeholder = "Created programatically"
        fieldCreatedOnTheFly.materialDelegate = self
        self.view.addSubview(fieldCreatedOnTheFly)
    }
    
    func materialTextFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }// return NO to disallow editing.
    
    func materialTextFieldDidBeginEditing(textField: UITextField) {
    }// became first responder

    func materialTextFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    
    func materialTextFieldDidEndEditing(textField: UITextField) {
        
    }// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    func materialTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }// return NO to not change text
    
    func materialTextFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }// called when clear button pressed. return NO to ignore (no notifications)
    
    func materialTextFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }// called when 'return' key pressed. return NO to ignore.
}

