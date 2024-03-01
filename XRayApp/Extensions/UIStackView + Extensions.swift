//
//  UIStackView + Extensions.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 26.01.2024.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = .equalSpacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
