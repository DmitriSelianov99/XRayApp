//
//  UserDefaultsSetting.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 07.02.2024.
//

import Foundation

class UserDefaultsSetting {
    static let shared = UserDefaultsSetting()
    
    init(){}

    
    func setDefaults() {
        UserDefaults.standard.setValue(false, forKey: "isUserAuthorised")
        UserDefaults.standard.setValue("", forKey: "userId")
    }

}
