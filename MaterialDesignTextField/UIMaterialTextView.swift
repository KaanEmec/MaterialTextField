//
//  UIMaterialTextView.swift
//  MaterialDesignTextField
//
//  Created by Kaan Emeç on 30.03.2015.
//  Copyright (c) 2015 KE. All rights reserved.
//
//  TODO:
//      - Documentation
//      - Set/Get implementations of Public Variables
//      - Border Options

import UIKit

@objc protocol UIMaterialTextViewDelegate : NSObjectProtocol {

    optional func materialTextFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    optional func materialTextFieldDidBeginEditing(textField: UITextField) // became first responder
    optional func materialTextFieldShouldEndEditing(textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    optional func materialTextFieldDidEndEditing(textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    optional func materialTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    
    optional func materialTextFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    optional func materialTextFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
}


class UIMaterialTextView: UITextField, UITextFieldDelegate {

    var materialDelegate: UIMaterialTextViewDelegate?
    private var PlaceHolderText: UILabel!
    private var TitleText: UILabel!
    private var placeHolderString: String = ""
    var animDurationFocus: NSTimeInterval = 0.2
    var animDurationLostFocus: NSTimeInterval = 0.4
    var animDurationEditing: NSTimeInterval = 0.3
    var placeHolderColor: UIColor = UIColor.grayColor()
    var activeTitleColor: UIColor = UIColor.blueColor()
    var inactiveTitleColor: UIColor = UIColor.grayColor()
    var initialPlaceHolderAlpha: CGFloat = 0.5

    required init(coder aDecoder: NSCoder?) {
        super.init(coder: aDecoder!)
    }
    
    override init(frame: CGRect) {
        let theFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: 40))
        super.init(frame: theFrame)
        self.delegate = self
        self.awakeFromNib()
    }
    
    override var placeholder: String? {
        get {
            return self.placeHolderString
        }
        set {
            if self.placeHolderString == "" {
                self.placeHolderString = newValue!
                PlaceHolderText = UILabel(frame: CGRect(x: padding.left, y: padding.top + 10, width: self.frame.width, height: self.frame.height-padding.top))
                PlaceHolderText.text = self.placeHolderString
                PlaceHolderText.font = self.font
                PlaceHolderText.textColor = self.placeHolderColor
                PlaceHolderText.alpha = self.initialPlaceHolderAlpha
                PlaceHolderText.sizeToFit()
                
                TitleText = UILabel(frame: CGRect(x: padding.left, y:14, width: self.frame.width, height: self.frame.height))
                TitleText.text = self.placeHolderString
                TitleText.font = UIFont(name: PlaceHolderText.font.familyName, size: 10)
                TitleText.textColor = self.inactiveTitleColor
                TitleText.sizeToFit()
                TitleText.alpha = 0.0
                
                self.addSubview(PlaceHolderText)
                self.addSubview(TitleText)
            } else {
                self.placeHolderString = newValue!
                PlaceHolderText.text = self.placeHolderString
                PlaceHolderText.sizeToFit()
                TitleText.text = self.placeHolderString
                TitleText.sizeToFit()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderStyle = UITextBorderStyle.None
        self.layer.borderWidth = 0
        
        var Line = UIView(frame: CGRect(x: padding.left/2, y: self.frame.height-2, width: self.frame.width, height: 1))
        Line.backgroundColor = UIColor.grayColor()
        
        self.addSubview(Line)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" && countElements(string)>0 {
            TitleText.textColor = self.activeTitleColor
            UIView.animateWithDuration(animDurationEditing - 0.1, animations: { () -> Void in
                self.PlaceHolderText.alpha = 0.0
            }, completion: nil)
                    
            UIView.animateWithDuration(animDurationEditing, animations: { () -> Void in
                self.TitleText.alpha = 1
                self.TitleText.frame = CGRect(x: self.padding.left, y:-14, width: textField.frame.width, height: textField.frame.height)
            }, completion: nil)
        }
        
        return materialDelegate?.materialTextField?(textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "" {
                UIView.animateWithDuration(animDurationFocus, animations: { () -> Void in
                    self.PlaceHolderText.alpha = 1
                    }, completion: nil)
        } else {
                UIView.transitionWithView(self.TitleText, duration: animDurationFocus, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                        self.TitleText.textColor = self.activeTitleColor
                }, completion: nil)
        }
        materialDelegate?.materialTextFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != "" {
            UIView.transitionWithView(self.TitleText, duration: animDurationLostFocus - 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.TitleText.textColor = self.inactiveTitleColor
            }, completion: nil)
        } else {
            UIView.animateWithDuration(animDurationLostFocus, animations: { () -> Void in
                self.PlaceHolderText.alpha = self.initialPlaceHolderAlpha
            }, completion: nil)
                    
            UIView.animateWithDuration(animDurationLostFocus, animations: { () -> Void in
                self.TitleText.alpha = 0
                self.TitleText.frame = CGRect(x: self.padding.left, y:-5, width: textField.frame.width, height: textField.frame.height)
            }, completion: {(completed) -> Void in
                self.TitleText.frame = CGRect(x: self.padding.left, y:14, width: textField.frame.width, height: textField.frame.height)
            })
        }
        
        materialDelegate?.materialTextFieldDidEndEditing?(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldReturn?(textField) ?? true // called when 'return' key pressed. return NO to ignore.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldBeginEditing?(textField) ?? true // called when 'return' key pressed. return NO to ignore.
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldEndEditing?(textField) ?? true
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldClear?(textField) ?? true
    }
    
    
    private let padding = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        return newBounds
    }
}
