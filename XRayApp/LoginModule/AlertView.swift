//
//  AlertViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 01.03.2024.
//

import UIKit

class AlertView {
    
    static let shared = AlertView()

    init(){}
    
    func addAlertController(in viewController: UIViewController) {
        let alert = UIAlertController(title: "Ошибка!", message: "Неверный логин или пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
