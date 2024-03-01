//
//  UITextField + Extensions.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 31.01.2024.
//

import Foundation
import UIKit

extension UITextField: UITextFieldDelegate {
    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
        self.font = .robotoMedium16()
        self.layer.cornerRadius = 12
        self.clearButtonMode = .whileEditing
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftViewMode = .always
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.returnKeyType = .continue
        self.backgroundColor = .specialTextField
        self.translatesAutoresizingMaskIntoConstraints = false
        
        delegate = self
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
