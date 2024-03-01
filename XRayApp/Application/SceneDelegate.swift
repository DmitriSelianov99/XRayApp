//
//  SceneDelegate.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 20.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //UserDefaultsSetting.shared.setDefaults() //для сброса авторизации
        let userDefaults = UserDefaults.standard
        
        window = UIWindow(windowScene: windowScene)
        
        let isAuthorised = userDefaults.bool(forKey: "isUserAuthorised")
        if isAuthorised == false {
            window?.rootViewController = LoginViewController()
        } else {
            window?.rootViewController = TabBarController()
        }
        
        window?.makeKeyAndVisible()
    }


}

