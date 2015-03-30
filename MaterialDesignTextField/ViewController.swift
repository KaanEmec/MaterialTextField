//
//  ViewController.swift
//  MaterialDesignTextField
//
//  Created by Kaan Emeç on 30.03.2015.
//  Copyright (c) 2015 KE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var myTextField = UITextField(frame: CGRect(x: 20, y: 120, width: 300, height: 46))
        myTextField.placeholder = "Title"
        myTextField.borderStyle = UITextBorderStyle.None
        myTextField.layer.borderWidth = 0
        self.view.addSubview(myTextField)
        myTextField.delegate = self
        
        var Line = UIView(frame: CGRect(x: 0, y: myTextField.frame.height-2, width: myTextField.frame.width, height: 1))
        Line.backgroundColor = UIColor.grayColor()
        myTextField.addSubview(Line)
        
        var placeHolderString = myTextField.placeholder
        myTextField.placeholder = ""
        
        var PlaceHolderText = UILabel(frame: CGRect(x: padding.left, y: padding.top + 8, width: myTextField.frame.width, height: myTextField.frame.height-padding.top))
        PlaceHolderText.text = placeHolderString
        PlaceHolderText.font = myTextField.font
        PlaceHolderText.textColor = UIColor.grayColor()
        PlaceHolderText.sizeToFit()
        
        myTextField.addSubview(PlaceHolderText)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "" {
        if let placeHolder = textField.subviews[1] as? UILabel {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                placeHolder.transform = CGAffineTransformScale(placeHolder.transform, 0.8, 0.8)
                placeHolder.frame = CGRect(x: padding.left, y: 2, width: placeHolder.frame.width, height: placeHolder.frame.height)
                }, completion: { (completed) -> Void in
                if completed {
                    UIView.transitionWithView(placeHolder, duration: 3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                        placeHolder.textColor = UIColor.blueColor()
                        }, completion: nil)
                }
            })
            }}
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
        if let placeHolder = textField.subviews[1] as? UILabel {
            UIView.transitionWithView(placeHolder, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    placeHolder.textColor = UIColor.grayColor()
                }, completion: { (completed) -> Void in
                        if completed {
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                            placeHolder.transform = CGAffineTransformScale(placeHolder.transform, 1.25, 1.25)
                            placeHolder.frame = CGRect(x: padding.left, y: padding.top + 8, width: placeHolder.frame.width, height: placeHolder.frame.height)
                            })
                    }
            })
            }
        }
    }
    
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        //UIView.animateWithDuration(1.0, animations: { () -> Void in
        //    if let plc = self.myTextField.subviews[0] as? UILabel {
        //        plc.textColor = UIColor.whiteColor()
        //    }
        //    })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

