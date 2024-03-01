//
//  XrayViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 02.02.2024.
//

import UIKit
import PhotosUI

class XrayViewController: UIViewController {
    
    private var model = PatientModel()
    
//MARK: - ELEMENTS
    private let headerLabel = UILabel(forHeader: "Рентген-снимок")
    
    private lazy var returnButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let xrayPhotoImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let xrayCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let noPhotoImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "noImage")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var addXrayButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Добавить снимок", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.robotoMedium16()
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .specialBlue
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var deleteXrayButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Удалить снимок", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        btn.titleLabel?.font = UIFont.robotoMedium16()
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .specialRed
        btn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
//MARK: - FUNCTIONS
    private func uploadImage(image: UIImage) {
        guard let url = URL(string: "http://192.168.1.149:5000/upload") else { return }

            // Создание запроса
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // Подготовка изображения для отправки
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            // Формирование тела запроса
            var body = Data()
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            // Установка тела запроса
            request.httpBody = body

            // Отправка запроса
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse,
                       httpResponse.statusCode == 200,
                       let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: []),
                       let jsonDict = jsonObject as? [String: Any],
                       let base64String = jsonDict["image"] as? String,
                       let imageData = Data(base64Encoded: base64String),
                       let image = UIImage(data: imageData) {
                // Используйте изображение (image) по вашему усмотрению
                DispatchQueue.main.async {
                    self.xrayPhotoImageView.image = image
                }
                print("Image received and processed.")
            } else {
                print("Error decoding image data.")
            }
        }.resume()
    }
    
    private func setupXray() {
        guard let data = model.xrayPhoto, let image = UIImage(data: data) else { return }
        xrayPhotoImageView.image = image
        
        noPhotoImageView.isHidden = true
        xrayCoverView.isHidden = true
        
        if xrayPhotoImageView.image != nil {
            addXrayButton.setTitle("Изменить снимок", for: .normal)
        }
    }
    
//MARK: - objc
    @objc private func returnButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            
            if #available(iOS 14, *) {
                self.presentImagePicker()
            } else {
                self.chooseImagePicker(source: source)
            }
        }
        
    }
    
    @objc private func deleteButtonTapped() {
        RealmManager.shared.deleteXray(model: model)
        xrayPhotoImageView.image = UIImage()
        xrayCoverView.isHidden = false
        noPhotoImageView.isHidden = false
    }
    
//MARK: - CONFIG FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setupXray()
    }
    
    convenience init(model: PatientModel) {
        self.init()
        
        self.model = model
        print(model)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(returnButton)
        view.addSubview(xrayCoverView)
        view.addSubview(noPhotoImageView)
        view.addSubview(xrayPhotoImageView)
        view.addSubview(addXrayButton)
        view.addSubview(deleteXrayButton)
    }
}

//MARK: - EXTENSIONS
extension XrayViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            xrayCoverView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            xrayCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            xrayCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            xrayCoverView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.7),
            
            noPhotoImageView.centerXAnchor.constraint(equalTo: xrayCoverView.centerXAnchor),
            noPhotoImageView.centerYAnchor.constraint(equalTo: xrayCoverView.centerYAnchor),
            
            xrayPhotoImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            xrayPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            xrayPhotoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            xrayPhotoImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.7),
            
            addXrayButton.topAnchor.constraint(equalTo: xrayPhotoImageView.bottomAnchor, constant: 20),
            addXrayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addXrayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addXrayButton.heightAnchor.constraint(equalToConstant: 40),
            
            deleteXrayButton.topAnchor.constraint(equalTo: addXrayButton.bottomAnchor, constant: 10),
            deleteXrayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            deleteXrayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            deleteXrayButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension XrayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        xrayPhotoImageView.image = image
        xrayPhotoImageView.contentMode = .scaleAspectFit
        xrayCoverView.isHidden = true
        noPhotoImageView.isHidden = true
        dismiss(animated: true)
    }
}

@available(iOS 14, *)
extension XrayViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.xrayPhotoImageView.image = image
                    self.xrayPhotoImageView.contentMode = .scaleAspectFit
                    self.xrayCoverView.isHidden = true
                    self.noPhotoImageView.isHidden = true
                    RealmManager.shared.updateModel(self.model, image: image.pngData() ?? Data())
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
