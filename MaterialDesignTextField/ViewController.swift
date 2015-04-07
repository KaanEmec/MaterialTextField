//
//  ViewController.swift
//  MaterialDesignTextField
//
//  Created by Kaan Emeç on 30.03.2015.
//  Copyright (c) 2015 KE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIMaterialTextFieldDelegate {
    
    @IBOutlet var ArtistField: UIMaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
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

