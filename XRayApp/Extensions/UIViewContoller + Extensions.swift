//
//  UIViewContoller + Extensions.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 24.01.2024.
//

import UIKit

extension UIViewController {
    
    func alertPhotoOrCamera(completionHandler: @escaping (UIImagePickerController.SourceType) -> Void){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        

        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            let camera = UIImagePickerController.SourceType.camera
            completionHandler(camera)
        }
        
        let photoLibrary = UIAlertAction(title: "Галерея", style: .default) { _ in
            let photoLibrary = UIImagePickerController.SourceType.photoLibrary
            completionHandler(photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    //MARK: - GestureRecognizer

    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipe.cancelsTouchesInView = false
        view.addGestureRecognizer(swipe)
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
