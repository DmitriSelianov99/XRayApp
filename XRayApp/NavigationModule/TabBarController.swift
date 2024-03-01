//
//  TabBarController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 30.01.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let mainVC = MainViewController()
    private let newPatientVC = NewPatientViewController()
    private let settingsVC = SettingsViewController()
    
    
    //buttons
    private lazy var btn1 = getButton(icon: "house", tag: 0, action: action, opacity: 1)
    private lazy var btn2 = getButton(icon: "person.badge.plus", tag: 1, action: action)
    private lazy var btn3 = getButton(icon: "gear", tag: 2, action: action)
    
    //action
    lazy var action = UIAction { [weak self] sender in
        guard let sender = sender.sender as? UIButton,
                let self = self
        else { return }
        
        self.selectedIndex = sender.tag
        setOpacity(tag: sender.tag)
    }
    
    private lazy var customBar: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = .specialMenu
        $0.frame = CGRect(x: 20, y: view.frame.height - 80, width: view.frame.width - 40, height: 50)
        $0.layer.cornerRadius = 25
        
        $0.addArrangedSubview(UIView())
        $0.addArrangedSubview(btn1)
        $0.addArrangedSubview(btn2)
        $0.addArrangedSubview(btn3)
        $0.addArrangedSubview(UIView())
        return $0
    }(UIStackView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customBar)
        tabBar.isHidden = true
        
        mainVC.title = "Главная"
        newPatientVC.title = "+"
        settingsVC.title = "Настройки"
        
        
        setViewControllers([mainVC, newPatientVC, settingsVC], animated: true)
    }
    
    private func getButton(icon: String, tag: Int, action: UIAction, opacity: Float = 0.5) -> UIButton {
        return {
            $0.setImage(UIImage(systemName: icon), for: .normal)
            $0.tintColor = .black
            $0.layer.opacity = opacity
            $0.tag = tag
            return $0
        }(UIButton(primaryAction: action))
    }
    
    private func setOpacity(tag: Int) {
        [btn1, btn2, btn3].forEach { btn in
            if btn.tag != tag {
                btn.layer.opacity = 0.5
            } else {
                btn.layer.opacity = 1
            }
        }
    }

}

//MARK: -  один из вариантов, в целом изи кастомный делать
//class TabBarController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        setViewControllers([mainVC, newPatientVC, testVC], animated: true)
//    }
//
//    private func setupViews() {
//        customBar = UIStackView(arrangedSubviews: [UIView() ,mainBtn, newPatientBtn, testBtn, UIView()], axis: .horizontal, spacing: 10)
//        customBar.translatesAutoresizingMaskIntoConstraints = true
//        customBar.backgroundColor = .specialMenu
//        customBar.alignment = .center
//        customBar.layer.cornerRadius = 25
//        customBar.frame = CGRect(x: 20, y: Int(view.frame.height) - 80, width: Int(view.frame.width) - 40, height: 50)
//
//        view.addSubview(customBar)
//        tabBar.isHidden = true
//    }
//
//    private let mainVC = MainViewController()
//    private let newPatientVC = NewPatientViewController()
//    private let testVC = ScanViewController()
//
//    private var currentTag = 0
//
//    //MARK: - BUTTONS
//    private lazy var mainBtn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.isSelected = true
//        btn.tag = 0
//        btn.tintColor = .black
//        btn.setImage(UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.setImage(UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
//        btn.addTarget(self, action: #selector(selectPage), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    private lazy var newPatientBtn: UIButton = {
//        let btn = UIButton()
//        btn.tag = 1
//        btn.tintColor = .black
//        btn.setImage(UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.setImage(UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
//        btn.addTarget(self, action: #selector(selectPage), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    private lazy var testBtn: UIButton = {
//        let btn = UIButton()
//        btn.tag = 2
//        btn.tintColor = .black
//        btn.setImage(UIImage(systemName: "list.bullet.clipboard")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.setImage(UIImage(systemName: "list.bullet.clipboard.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
//        btn.addTarget(self, action: #selector(selectPage), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    private var customBar = UIStackView()
//
//    @objc private func selectPage(_ sender: UIButton) {
//        self.selectedIndex = sender.tag
//        sender.isSelected = true
//
//        for btn in [mainBtn, newPatientBtn, testBtn] {
//            if sender.tag != btn.tag {
//                btn.isSelected = false
//            }
//        }
//
//    }
//
//}
