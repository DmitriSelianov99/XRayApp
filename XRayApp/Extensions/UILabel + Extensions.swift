//
//  UILabel + Extensions.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 31.01.2024.
//

import UIKit

extension UILabel {
    convenience init(forHeader text: String){
        self.init()
        self.text = text
        self.font = .robotoBold22()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
