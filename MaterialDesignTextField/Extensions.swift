//
//  Extensions.swift
//  MaterialDesignTextField
//
//  Created by Kaan Emeç on 30.03.2015.
//  Copyright (c) 2015 KE. All rights reserved.
//

import Foundation
import UIKit

let padding = UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0);

extension UITextField {
    
    
    func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        return newBounds
    }
}