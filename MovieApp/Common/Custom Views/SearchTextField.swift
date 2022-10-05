//
//  SearchTextField.swift
//  MovieApp
//
//  Created by Akin on 5.10.2022.
//

import UIKit

class SearchTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
