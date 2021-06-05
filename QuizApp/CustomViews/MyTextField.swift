//
//  MyTextField.swift
//  QuizApp
//
//  Created by Kompjuter on 12/04/2021.
//

import Foundation
import UIKit

class MyTextField: UITextField {
    let padding = UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
}
