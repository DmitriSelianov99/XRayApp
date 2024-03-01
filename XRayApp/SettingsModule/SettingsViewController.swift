//
//  SettingsViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 08.02.2024.
//

import UIKit

class SettingsViewController: UITabBarController {
    
    private let headerLabel = UILabel(forHeader: "Настройки")
    
    private lazy var exitButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .specialRed
        btn.layer.cornerRadius = 12
        btn.setTitle("Выйти", for: .normal)
        btn.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(exitButton)
    }
    
    @objc private func exitButtonTapped() {
        dismiss(animated: true)
        UserDefaultsSetting.shared.setDefaults()
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

}

extension SettingsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}
