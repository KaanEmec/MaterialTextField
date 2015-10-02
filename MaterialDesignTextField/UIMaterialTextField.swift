//
//  UIMaterialTextField.swift
//
//  This is a textfield subclass with a totally different look. The design and animations are inspired by Google's material design language.
//
//  Created by Kaan Emeç on 30.03.2015.
//
//  ----------------------------------------------------------------------------------
//  ----------------------------------------------------------------------------------
//  USAGE: Placing a UIMaterialTextField on a view is fairly straightforward. There are 2 ways:
//
//  1. Using Interface Builder & Standard UITextField
//      - Place a standard UITextField using Interface Builder
//      - Change the UITextField object's class as: UIMaterialTextField (Using Interface Builder)
//      - Change the UITextField object's border style to none (Using Interface Builder)
//      - Change the UITextField object's height to 40
//      - Enter a placeholder text as the title of the field (You can change or define the placeholder during runtime also)
//
//  2. Creating it through code without the interface builder
//      - Use the initializer UIMaterialTextField(frame: CGRect)
//      - Add the created object to your desired view.
//      - Define a placeholder text as the title of the field (You can change or define the placeholder during runtime also)
//
//  DELEGATE:
//   - If you want to use event handling you should define the .materialDelegate property of a UIMaterialTextField.
//   - You should add "UIMaterialTextFieldDelegate" protocol to the view's class definition.
//
//

import UIKit

@objc protocol UIMaterialTextFieldDelegate : NSObjectProtocol {
    
    optional func materialTextFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    optional func materialTextFieldDidBeginEditing(textField: UITextField) // became first responder
    optional func materialTextFieldShouldEndEditing(textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    optional func materialTextFieldDidEndEditing(textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    optional func materialTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    
    optional func materialTextFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    optional func materialTextFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
}


class UIMaterialTextField: UITextField, UITextFieldDelegate {
    
    var materialDelegate: UIMaterialTextFieldDelegate?
    
    private var PlaceHolderText = UILabel()
    // The Placeholder label that fades out when a text is entered.
    
    private var TitleText = UILabel()
    // The Title label that fades in when a text is entered.
    
    private var placeHolderString: String = ""
    // The placeHolderString variable is used by the PlaceHolder property to get/set the placeholder text
    
    private var Line = UIView()
    // The bottom line of the textfield.
    
    private var _initialPlaceHolderAlpha: CGFloat = 0.5
    // Private variable used to store the value of initialPlaceHolderAlpha property
    
    private var _activeTitleColor = UIColor.blueColor()
    // Private variable used to store the value of activeTitleColor property
    
    private var _inactiveTitleColor = UIColor.darkGrayColor()
    // Private variable used to store the value of inactiveTitleColor property
    
    private var _lineColor = UIColor.lightGrayColor()
    // Private variable used to store the value of lineColor property
    
    private var _placeHolderColor = UIColor.darkGrayColor()
    // Private variable used to store the value of placeHolderColor property
    
    
    enum MaterialTextFieldState {
        case inactiveNotEdited
        case inactiveEdited
        case focusedNotEdited
        case focusedAndEdited
    }
    
    
    // --------------------------------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    // -------  PROPERTIES  -----------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    
    
    // Duration of the animation when the object is focused
    var animDurationFocus: NSTimeInterval = 0.2
    
    // Duration of the animation when the object loses focus
    var animDurationLostFocus: NSTimeInterval = 0.4
    
    // Duration of the animation when the placeholder fades out and title text fades in
    var animDurationEditing: NSTimeInterval = 0.3
    
    // Actual state of the text field
    var currentState = MaterialTextFieldState.inactiveNotEdited
    
    
    // ---------------------------------------------------------------------------------------------------
    // The placeholder property which overries the original placeholder property of the parent UITextField
    // This property is overrided because the PlaceHolderText label and TitleText label should be updated
    // when this property is changed
    // ---------------------------------------------------------------------------------------------------
    override var placeholder: String? {
        get {
            return placeHolderString
        }
        set {
            self.placeHolderString = newValue!
            PlaceHolderText.text = self.placeHolderString
            PlaceHolderText.sizeToFit()
            TitleText.text = self.placeHolderString
            TitleText.sizeToFit()
        }
    }
    
    
    // ---------------------------------------------------------------------------------------------------
    // The text property which overries the original text property of the parent UITextField
    // This property is overrided because an animation should be run when a text is entered.
    // ---------------------------------------------------------------------------------------------------
    override var text:String? {
        get{
            return super.text
        }
        set {
            super.text = newValue
            self.TextChangedInRuntime()
        }
    }
    
    
    // ------------------------------------------------------------------------------------
    // The alpha value of the placeholder text when the textfield is not focused
    // ------------------------------------------------------------------------------------
    var initialPlaceHolderAlpha: CGFloat {
        get {
            return self._initialPlaceHolderAlpha
        }
        set {
            self._initialPlaceHolderAlpha = newValue
            if currentState == MaterialTextFieldState.inactiveNotEdited {
                PlaceHolderText.alpha = self.initialPlaceHolderAlpha
            }
        }
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // The textcolor value of the title text when the textfield is focused & being edited
    // ------------------------------------------------------------------------------------
    var activeTitleColor: UIColor {
        get {
            return self._activeTitleColor
        }
        set {
            self._activeTitleColor = newValue
            if currentState == MaterialTextFieldState.focusedAndEdited {
                TitleText.textColor = self.activeTitleColor
            }
        }
    }
    
    
    // ------------------------------------------------------------------------------------
    // The textcolor value of the title text when the textfield is filled but not focused
    // ------------------------------------------------------------------------------------
    var inactiveTitleColor: UIColor {
        get{
            return self._inactiveTitleColor
        }
        set {
            self._inactiveTitleColor = newValue
            if currentState == MaterialTextFieldState.inactiveNotEdited || currentState == MaterialTextFieldState.focusedNotEdited ||  currentState == MaterialTextFieldState.inactiveEdited {
                TitleText.textColor = self.inactiveTitleColor
            }
        }
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // The color value of the placeholder text (you can change the alpha value for editing the difference of placeholder color of a focused object and unfocused object.
    // ------------------------------------------------------------------------------------
    var placeHolderColor: UIColor {
        get{
            return self._placeHolderColor
        }
        set {
            self._placeHolderColor = newValue
            PlaceHolderText.textColor = self.placeHolderColor
        }
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // The color value of the bottom line
    // ------------------------------------------------------------------------------------
    var lineColor: UIColor {
        get{
            return self._lineColor
        }
        set {
            self._lineColor = newValue
            Line.backgroundColor = self.lineColor
        }
    }
    
    
    
    
    
    
    // --------------------------------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    // -------  INITIALIZERS  ---------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    
    // ------------------------------------------------------------------------------------
    // The default initializer
    // ------------------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder?) {
        super.init(coder: aDecoder!)
        // The delegate of the parent UITextfield is set to self to handle focus, text editing and loose focus events
        self.delegate = self
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // "Init with frame" will create a UITextField by the given fram.
    // This initializer will ignore the frame height and always set the height to 40
    // ------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        let theFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: 40))
        super.init(frame: theFrame)
        initializeMaterialDesign() // Transform the created UITextField to MaterialDesign look
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // The awakeFromNib initializer
    // ------------------------------------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeMaterialDesign() // Transform the created UITextField to MaterialDesign look
    }
    
    
    
    
    // -------------------------------------------------------------------------------------
    // This initializer converts the super UITextField object to the UIMaterialTextField by:
    //    - Adding Placeholder label as a subview
    //    - Erasing the parent UITextField's placeholder
    //    - Adding TitleText label as a subview and hiding it as initially it is not shown
    //    - Creating a view object for the bottom line
    // ------------------------------------------------------------------------------------
    func initializeMaterialDesign() {
        self.placeHolderString = String(super.placeholder!)
        super.placeholder = ""
        
        Line = UIView(frame: CGRect(x: padding.left/2, y: self.frame.height-2, width: self.frame.width, height: 1))
        Line.backgroundColor = lineColor
        
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
        
        self.addSubview(Line)
        self.addSubview(PlaceHolderText)
        self.addSubview(TitleText)
        self.backgroundColor = UIColor.clearColor()
        self.borderStyle = UITextBorderStyle.None
        self.layer.borderWidth = 0
    }
    
    
    
    
    
    
    
    // --------------------------------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    // -------  ANIMATIONS & DELEGATES  -----------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    // --------------------------------------------------------------------------------------------------------
    
    
    
    // --------------------------------------------------------------------------------------
    // When the textField is focused
    //    - If the field is empty increase the PlaceHolderText's alpha
    //    - If the field is not empty just change the color of the litte title to activeColor
    // --------------------------------------------------------------------------------------
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "" {
            UIView.animateWithDuration(animDurationFocus, animations: { () -> Void in
                self.PlaceHolderText.alpha = 1
                }, completion: nil)
            currentState = MaterialTextFieldState.focusedNotEdited
            
        } else {
            UIView.transitionWithView(self.TitleText, duration: animDurationFocus, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.TitleText.textColor = self.activeTitleColor
                }, completion: nil)
            currentState = MaterialTextFieldState.focusedAndEdited
            
        }
        
        // Calls the related delegate function of UIMaterialTextFieldDelegate protocol
        materialDelegate?.materialTextFieldDidBeginEditing?(textField)
    }
    
    
    
    // ---------------------------------------------------------------------------------------
    // When a text is entered
    //    - If the field is empty fade out the PlaceHolderText label and show the little title
    //    - If the field is already filled do nothing
    // ---------------------------------------------------------------------------------------
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" && string.characters.count>0 {
            TitleText.textColor = self.activeTitleColor
            UIView.animateWithDuration(animDurationEditing - 0.1, animations: { () -> Void in
                self.PlaceHolderText.alpha = 0.0
                }, completion: nil)
            
            UIView.animateWithDuration(animDurationEditing, animations: { () -> Void in
                self.TitleText.alpha = 1
                self.TitleText.frame = CGRect(x: self.padding.left, y:-14, width: self.frame.width, height: self.frame.height)
                }, completion: nil)
            currentState = MaterialTextFieldState.focusedAndEdited
        }
        
        // Calls the related delegate function of UIMaterialTextFieldDelegate protocol and returns its value if it exists. If not always returns true.
        return materialDelegate?.materialTextField?(textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }
    
    
    
    // ----------------------------------------------------------------------------------------------------------------
    // When a text loses the focus
    //    - If the field is filled do nothing change the color of TitleText to inactiveTitleColor
    //    - If the field is empty decrease the alpha of the PlaceHolderText again and hide the title text by fading out
    // ----------------------------------------------------------------------------------------------------------------
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != "" {
            UIView.transitionWithView(self.TitleText, duration: animDurationLostFocus - 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.TitleText.textColor = self.inactiveTitleColor
                }, completion: nil)
            currentState = MaterialTextFieldState.inactiveNotEdited
            
        } else {
            UIView.animateWithDuration(animDurationLostFocus, animations: { () -> Void in
                self.PlaceHolderText.alpha = self.initialPlaceHolderAlpha
                }, completion: nil)
            
            UIView.animateWithDuration(animDurationLostFocus, animations: { () -> Void in
                self.TitleText.alpha = 0
                self.TitleText.frame = CGRect(x: self.padding.left, y:-5, width: self.frame.width, height: self.frame.height)
                }, completion: {(completed) -> Void in
                    self.TitleText.frame = CGRect(x: self.padding.left, y:14, width: self.frame.width, height: self.frame.height)
            })
            currentState = MaterialTextFieldState.inactiveEdited
        }
        
        // Calls the related delegate function of UIMaterialTextFieldDelegate protocol
        materialDelegate?.materialTextFieldDidEndEditing?(textField)
    }
    
    
    // ------------------------------------------------------------------------------------
    // TextChangedInRuntime function calls textField shouldChangeCharactersInRange function
    // This function is needed to run the "first text is entered animation" when the text
    // value of the field is changed without the keyboard (using runtime code)
    // ------------------------------------------------------------------------------------
    private func TextChangedInRuntime(){
        let theRange = NSMakeRange(0, self.text!.characters.count)
        textField(UITextField(),shouldChangeCharactersInRange: theRange, replacementString: self.text!)
        textFieldDidEndEditing(self)
    }
    
    
    
    // ---------------------------------------------------------------------------
    // Calls the related delegate function of UIMaterialTextFieldDelegate protocol
    // and returns its value if it exists. If not always returns true.
    // ---------------------------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldReturn?(textField) ?? true // called when 'return' key pressed. return NO to ignore.
    }
    
    // ---------------------------------------------------------------------------
    // Calls the related delegate function of UIMaterialTextFieldDelegate protocol
    // and returns its value if it exists. If not always returns true.
    // ---------------------------------------------------------------------------
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldBeginEditing?(textField) ?? true // called when 'return' key pressed. return NO to ignore.
    }
    
    // ---------------------------------------------------------------------------
    // Calls the related delegate function of UIMaterialTextFieldDelegate protocol
    // and returns its value if it exists. If not always returns true.
    // ---------------------------------------------------------------------------
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldEndEditing?(textField) ?? true
    }
    
    // ---------------------------------------------------------------------------
    // Calls the related delegate function of UIMaterialTextFieldDelegate protocol
    // and returns its value if it exists. If not always returns true.
    // ---------------------------------------------------------------------------
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return materialDelegate?.materialTextFieldShouldClear?(textField) ?? true
    }
    
    
    
    // ---------------------------------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------------------------------
    // This part overrides the padding delegates of the parent UItextfield to create space for custom UILabel views.
    // ---------------------------------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------------------------------
    
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
