//
//  DetailedInfoViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 26.01.2024.
//

import UIKit
import PhotosUI

class DetailedInfoViewController: UIViewController {
    
    private var patientModel = PatientModel()
    
//MARK: - ELEMENTS
    private let closeButtonView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "closeButton")?.withRenderingMode(.alwaysOriginal)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let cardView = CardView()
    
    private lazy var showXrayButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Показать снимок       ", for: .normal)
        btn.backgroundColor = .specialBlue
        btn.tintColor = .white
        btn.titleLabel?.font = .robotoMedium16()
        btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(showXrayTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
      
//MARK: - CONFIG FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addCloseGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(cardView)
        view.addSubview(closeButtonView)
        view.addSubview(showXrayButton)
    }
    
    private func addCloseGesture(){
        let closeButtonGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonViewTapped))
        closeButtonView.isUserInteractionEnabled = true
        closeButtonView.addGestureRecognizer(closeButtonGesture)
    }
    
//MARK: - FUNCTIONS
    public func setModel(model: PatientModel){
        patientModel = model
        cardView.setData(model: model)
    }

//MARK: - objc
    @objc private func closeButtonViewTapped() {
        dismiss(animated: true)
    }
    
//    @objc private func addButtonTapped(){
//        let viewCOntrollerToPresent = ScanViewController()
//        viewCOntrollerToPresent.loadPhotoDelegate = self
//        if let sheet = viewCOntrollerToPresent.sheetPresentationController {
//            sheet.detents = [.medium(), .large()] //определение высоты контроллера
//            sheet.largestUndimmedDetentIdentifier = .medium //интерактивный вид затемнения. Можно взаимодействовать с объектами сзади
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false //чтобы можно было листать не раскрывая. Лучше с коллекцией это делать
//            sheet.prefersEdgeAttachedInCompactHeight = true //для горизонтального положения
//            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true //для горизонтального положения
//            sheet.prefersGrabberVisible = true
//        }
//        present(viewCOntrollerToPresent, animated: true)
//    }

    
    @objc private func showXrayTapped() {
        let xrayVC = XrayViewController(model: patientModel)
        xrayVC.modalPresentationStyle = .fullScreen
        present(xrayVC, animated: true)
    }
}

//MARK: - EXTENSIONS
extension DetailedInfoViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            closeButtonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButtonView.heightAnchor.constraint(equalToConstant: 24),
            closeButtonView.widthAnchor.constraint(equalToConstant: 24),
            
            cardView.topAnchor.constraint(equalTo: closeButtonView.bottomAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.heightAnchor.constraint(equalToConstant: 140),
            
            showXrayButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            showXrayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            showXrayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            showXrayButton.heightAnchor.constraint(equalToConstant: 40),

        ])
    }
}
