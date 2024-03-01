//
//  NewPatientViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 30.01.2024.
//

import UIKit
import PhotosUI
import RealmSwift

class NewPatientViewController: UIViewController {
    
    private let patientModel = PatientModel()
    
//MARK: - ELEMENTS
    private let headerLabel = UILabel(forHeader: "Добавить пациента")
    private let nameTextField = UITextField(placeholder: "ФИО")
    private let genderTextField = UITextField(placeholder: "Выберите пол...")
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Женщина", "Мужчина"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialLightBlue
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.font : UIFont.robotoMedium16()!], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    //MARK: Дата рождения
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата рождения:"
        label.font = .robotoMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let birthdayDatepicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .specialBlue
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var birthdayStackView = UIStackView()
  
    //MARK:  Дата посещения
    private let visitLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата приема:"
        label.font = .robotoMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let visitDatepicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .specialBlue
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var visitStackView = UIStackView()
    
    private lazy var addXrayButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 12
        btn.tintColor = .black
        btn.titleLabel?.font = .robotoMedium16()
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.specialBlue.cgColor
        btn.setTitle("Добавить рентген-снимок", for: .normal)
        btn.addTarget(self, action: #selector(addXray), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var createPatientButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Создать пациента", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .specialBlue
        btn.addTarget(self, action: #selector(createPatient), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var refreshFieldsButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Сбросить данные", for: .normal)
        btn.backgroundColor = .specialRed
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(refreshFieldsValues), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
//MARK: - FUNCTIONS
    private func resetValues() {
        nameTextField.text = ""
        genderSegmentedControl.selectedSegmentIndex = 0
        birthdayDatepicker.date = Date()
        visitDatepicker.date = Date()
        
        addXrayButton.tintColor = .black
        addXrayButton.backgroundColor = .white
        addXrayButton.layer.borderColor = UIColor.specialBlue.cgColor
        addXrayButton.setTitle("Добавить рентген-снимок", for: .normal)
        addXrayButton.setImage(nil, for: .normal)
        
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 1
    }

//MARK: - CONFIG FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        
        addGesture()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(nameTextField)
        view.addSubview(genderSegmentedControl)
        
        birthdayStackView = UIStackView(arrangedSubviews: [birthdayLabel, birthdayDatepicker], axis: .horizontal, spacing: 20)
        view.addSubview(birthdayStackView)
        
        visitStackView = UIStackView(arrangedSubviews: [visitLabel, visitDatepicker], axis: .horizontal, spacing: 20)
        view.addSubview(visitStackView)
        
        view.addSubview(addXrayButton)
        
        view.addSubview(refreshFieldsButton)
        view.addSubview(createPatientButton)
        
    }
    
//MARK: - objc
    @objc private func segmentedChange(_ sender: UISegmentedControl){
        print(sender.selectedSegmentIndex)
    }
    
    @objc private func addXray(){
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            
            if #available(iOS 14, *) {
                self.presentImagePicker()
            } else {
                self.chooseImagePicker(source: source)
            }
        }
    }
    
    @objc private func createPatient(){
        
        guard nameTextField.hasText else {
            nameTextField.layer.borderColor = UIColor.specialRed.cgColor
            nameTextField.layer.borderWidth = 2
            return
        }
        
        patientModel.name = nameTextField.text ?? ""
        patientModel.sex = genderSegmentedControl.selectedSegmentIndex == 1 ? true : false
        patientModel.birthday = birthdayDatepicker.date
        patientModel.visitDate = visitDatepicker.date
        //рентген добавляется в extension
        patientModel.doctorId = UserDefaults.standard.string(forKey: "userId") ?? "404"
        
        RealmManager.shared.addModel(patientModel)
        resetValues()
    }
    
    @objc private func refreshFieldsValues(){
        let alertController = UIAlertController(title: "Сброс данных", message: "Вы действительно хотите очистить данные?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { [self] _ in
            resetValues()
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true)
    }
    
    
}

//MARK: - EXTENSIONS
extension NewPatientViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 56),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            birthdayStackView.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 20),
            birthdayStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            birthdayStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            visitStackView.topAnchor.constraint(equalTo: birthdayStackView.bottomAnchor, constant: 20),
            visitStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            visitStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            addXrayButton.topAnchor.constraint(equalTo: visitStackView.bottomAnchor, constant: 20),
            addXrayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addXrayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addXrayButton.heightAnchor.constraint(equalToConstant: 40),
            
            createPatientButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            createPatientButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            createPatientButton.trailingAnchor .constraint(equalTo: view.trailingAnchor, constant: -24),
            createPatientButton.heightAnchor.constraint(equalToConstant: 40),
            
            refreshFieldsButton.bottomAnchor.constraint(equalTo: createPatientButton.topAnchor, constant: -20),
            refreshFieldsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            refreshFieldsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            refreshFieldsButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension NewPatientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        patientModel.xrayPhoto = image?.pngData() ?? Data()
        dismiss(animated: true)
    }
}

@available(iOS 14, *)
extension NewPatientViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.patientModel.xrayPhoto = image.pngData() ?? Data()
                    self.addXrayButton.setTitle("Снимок загружен", for: .normal)
                    self.addXrayButton.tintColor = .white
                    self.addXrayButton.setImage(UIImage(systemName: "photo.badge.checkmark.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    self.addXrayButton.backgroundColor = .specialGreen
                    self.addXrayButton.layer.borderColor = UIColor.specialGreen.cgColor
                }
                
            }
        }
    }
    
    private func presentImagePicker(){
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
}

//MARK: - GestureRecognizer
//extension NewPatientViewController {
//    private func addGesture() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//        
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        swipe.cancelsTouchesInView = false
//        view.addGestureRecognizer(swipe)
//    }
//    
//    
//    @objc private func hideKeyboard() {
//        view.endEditing(true)
//    }
//}


