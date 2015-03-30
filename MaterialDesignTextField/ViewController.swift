//
//  ViewController.swift
//  MaterialDesignTextField
//
//  Created by Kaan Emeç on 30.03.2015.
//  Copyright (c) 2015 KE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var plp: UILabel!
    
    @IBOutlet var artistView: UIView!
    @IBOutlet var titleView: UIView!
    @IBOutlet var durationView: UIView!
    @IBOutlet var tagsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view, typically from a nib.
        

        
        var artistField = UIMaterialTextView(frame: artistView.frame)
        var titleField = UIMaterialTextView(frame: titleView.frame)
        var durationField = UIMaterialTextView(frame: durationView.frame)
        var tagsField = UIMaterialTextView(frame: tagsView.frame)
        
        artistView.removeFromSuperview()
        artistView = nil
        titleView.removeFromSuperview()
        titleView = nil
        tagsView.removeFromSuperview()
        tagsView = nil
        durationView.removeFromSuperview()
        durationView = nil
        
        artistField.activeTitleColor = UIColor.purpleColor()
        durationField.activeTitleColor = UIColor.purpleColor()
        titleField.activeTitleColor = UIColor.purpleColor()
        tagsField.activeTitleColor = UIColor.purpleColor()

        artistField.placeholder = "Artist"
        durationField.placeholder = "Duration"
        titleField.placeholder = "Title"
        tagsField.placeholder = "Tags"

        self.view.addSubview(artistField)
        self.view.addSubview(titleField)
        self.view.addSubview(durationField)
        self.view.addSubview(tagsField)
        
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

