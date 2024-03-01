//
//  LoginViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 06.02.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
//MARK: - ELEMENTS
    private let headerLabel = UILabel(forHeader: "Авторизация")
    private let loginTextfield = UITextField(placeholder: "Логин")
    private let passwordTextField = UITextField(placeholder: "Пароль")
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Войти", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .specialBlue
        btn.addTarget(self, action: #selector(enterTheApp), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var formStackView = UIStackView()
    
//MARK: - FUNCTIONS

    
//MARK: - CONFIG FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
        addGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        
        loginTextfield.heightAnchor.constraint(equalToConstant: 56).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        passwordTextField.isSecureTextEntry = true
        formStackView = UIStackView(arrangedSubviews: [loginTextfield, passwordTextField, loginButton], axis: .vertical, spacing: 20)
        view.addSubview(formStackView)
    }
    
//MARK: - objc
    @objc private func enterTheApp() {
        //let userId = UserDefaults.standard.string(forKey: "userId")
        //let isAuthorised = UserDefaults.standard.bool(forKey: "isUserAuthorised")
        
        let models = RealmManager.shared.getDoctors()
        let modelsArray = models.map { $0 }
        
        
        for model in modelsArray {
            if model.login == loginTextfield.text && model.password == passwordTextField.text {
                UserDefaults.standard.setValue(true, forKey: "isUserAuthorised")
                UserDefaults.standard.setValue("\(model._id)", forKey: "userId")
                
                loginTextfield.text = ""
                passwordTextField.text = ""
                
                dismiss(animated: true)
                let mainVC = TabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                present(mainVC, animated: true)
                print(mainVC.selectedIndex)
                
                return
            }
        }
        
        simpleAlert(title: "Ошибка!", message: "Неверный логин или пароль")
        
    }
    
}

//MARK: - EXTENSIONS
extension LoginViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            formStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            formStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            formStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
}
