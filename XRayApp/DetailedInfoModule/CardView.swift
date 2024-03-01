//
//  CardView.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 26.01.2024.
//

import UIKit

class CardView: UIView {
    
//MARK: - ELEMENTS
    private let cardCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBlue
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let patientPhoto: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "manAvatar")
        img.layer.cornerRadius = 24
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoBold18()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = "Иван Иванов"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium14()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = "33 года"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateOfAdmissionLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium12()
        label.textColor = .white
        label.text = "Дата приема:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium12()
        label.textColor = .white
        label.text = "01.01.1970"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateStackView = UIStackView()

    
//MARK: - CONFIG FUNCTIONS
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .none
        
        addSubview(cardCoverView)
        addSubview(patientPhoto)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(separatorView)
        
        dateStackView = UIStackView(arrangedSubviews: [dateOfAdmissionLabel, dateLabel], axis: .horizontal, spacing: 10)
        addSubview(dateStackView)
    }
    
//MARK: - FUNCTIONS
    public func setData(model: PatientModel){
        if model.sex {
            patientPhoto.image = UIImage(named: "manAvatar")
        } else {
            patientPhoto.image = UIImage(named: "womanAvatar")
        }
        
        nameLabel.text = model.name
        ageLabel.text = model.birthday.ddMMyyyyFromDate()
        dateLabel.text = model.visitDate.ddMMyyyyFromDate()
    }
}

//MARK: - EXTENSIONS
extension CardView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cardCoverView.topAnchor.constraint(equalTo: topAnchor),
            cardCoverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardCoverView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardCoverView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            patientPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            patientPhoto.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            patientPhoto.heightAnchor.constraint(equalToConstant: 48),
            patientPhoto.widthAnchor.constraint(equalToConstant: 48),
            
            nameLabel.topAnchor.constraint(equalTo: patientPhoto.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: patientPhoto.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: patientPhoto.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            dateStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
