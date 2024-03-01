//
//  PatientsCollectionViewCell.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 25.01.2024.
//

import UIKit

protocol PatientsCollectionViewCellProtocol: AnyObject {
    func detailedButtonTapped(model: PatientModel)
    func deleteModel(model: PatientModel)
}

class PatientsCollectionViewCell: UICollectionViewCell {
    
    weak var patientDelegate: PatientsCollectionViewCellProtocol?
    private var patientModel = PatientModel()
    
//MARK: - ELEMENTS
    private lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .specialRed
        
        let systemImage = UIImage(systemName: "trash")
        let imageWidth = 2 * (systemImage?.size.width)!
        
        btn.setImage(systemImage, for: .normal)
        btn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        btn.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = "Иван Иванов"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium14()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = "33 года"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailedButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .specialLightBlue.withAlphaComponent(0.1)
        btn.titleLabel?.font = .robotoMedium14()
        btn.setTitleColor(.specialBlue, for: .normal)
        btn.layer.cornerRadius = 20
        btn.setTitle("Детали", for: .normal)
        btn.addTarget(self, action: #selector(openDetailedInformation), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateOfAdmissionLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium12()
        label.textColor = .specialText
        label.text = "Дата приема:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium12()
        label.textColor = .specialText
        label.text = "01.01.1970"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateStackView = UIStackView()
    
    public var numOfCell = 0
    
//MARK: - objc
    @objc private func openDetailedInformation(){
        patientDelegate?.detailedButtonTapped(model: patientModel)
    }
    
    @objc private func deleteButtonTapped(){
        patientDelegate?.deleteModel(model: patientModel)
    }

//MARK: - CONFIG FUNCSTIONS
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialSeparator
        layer.cornerRadius = 12
        
        addSubview(deleteButton)
        addSubview(patientPhoto)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(separatorView)
        
        dateStackView = UIStackView(arrangedSubviews: [dateOfAdmissionLabel, dateLabel], axis: .horizontal, spacing: 10)
        addSubview(dateStackView)
        
        addSubview(detailedButton)
    }
    
    public func configure(model: PatientModel) {
        patientModel = model
        
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
extension PatientsCollectionViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            patientPhoto.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            patientPhoto.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            patientPhoto.heightAnchor.constraint(equalToConstant: 48),
            patientPhoto.widthAnchor.constraint(equalToConstant: 48),
            
            nameLabel.topAnchor.constraint(equalTo: patientPhoto.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: patientPhoto.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: patientPhoto.bottomAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            dateStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            detailedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailedButton.heightAnchor.constraint(equalToConstant: 40),
            detailedButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
}
