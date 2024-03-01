//
//  MainViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 20.01.2024.
//

import UIKit
import PhotosUI

protocol LoadPhotoProtocol: AnyObject {
    func loadPhoto(image: UIImage)
}

class ScanViewController: UIViewController {
    
    weak var loadPhotoDelegate: LoadPhotoProtocol?

//MARK: - ELEMENTS
    private let valueTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Send", for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var choosePhotoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Choose photo", for: .normal)
        btn.backgroundColor = .cyan
        btn.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var loadPhotoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Загрузить", for: .normal)
        btn.backgroundColor = .magenta
        btn.addTarget(self, action: #selector(loadPhoto), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let testImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "test")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
//MARK: - FUNCTIONS
    
    //MARK: первый тестовый код, отправляющий текст на сервер и возвращающий с Hello
    private func sendText(){
        let url = URL(string: "http://192.168.1.149:5000/process_data")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["text": valueTextField.text]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let result = json["result"] as? String {
                            DispatchQueue.main.async {
                                self.testLabel.text = result
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //MARK: отправка изображения на сервер
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
                    self.testImage.image = image
                }
                print("Image received and processed.")
            } else {
                print("Error decoding image data.")
            }
        }.resume()
    }
    
//MARK: - CONFIG FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("!!!!!")
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews(){
        view.backgroundColor = .green
        
        view.addSubview(valueTextField)
        view.addSubview(sendButton)
        view.addSubview(choosePhotoButton)
        view.addSubview(testLabel)
        view.addSubview(testImage)
        view.addSubview(loadPhotoButton)
    }
    
//MARK: - objc
    @objc private func sendButtonTapped(){
        uploadImage(image: testImage.image!)
        
    }
    
    @objc private func choosePhoto(){
        print("photo")
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            
            if #available(iOS 14, *) {
                self.presentImagePicker()
            } else {
                self.chooseImagePicker(source: source)
            }
            
            
        }
    }
    
    @objc private func loadPhoto() {
        loadPhotoDelegate?.loadPhoto(image: testImage.image!)
    }

}

//MARK: - EXTENSIONS
extension ScanViewController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            valueTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            valueTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            valueTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            valueTextField.heightAnchor.constraint(equalToConstant: 30),
            
            sendButton.topAnchor.constraint(equalTo: valueTextField.bottomAnchor, constant: 30),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            
            testLabel.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 30),
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            testImage.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: 30),
            testImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            testImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            testImage.heightAnchor.constraint(equalToConstant: 150),
            
            choosePhotoButton.topAnchor.constraint(equalTo: testImage.bottomAnchor, constant: 30),
            choosePhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            choosePhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            choosePhotoButton.heightAnchor.constraint(equalToConstant: 30),
            
            loadPhotoButton.topAnchor.constraint(equalTo: choosePhotoButton.bottomAnchor, constant: 20),
            loadPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loadPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loadPhotoButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}


extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        testImage.image = image
        testImage.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}

@available(iOS 14, *)
extension ScanViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.testImage.image = image
                    self.testImage.contentMode = .scaleAspectFit
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

