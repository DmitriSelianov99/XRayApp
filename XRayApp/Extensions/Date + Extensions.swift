//
//  Date + Extensions.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 26.01.2024.
//

import Foundation

extension Date {
    func ddMMyyyyFromDate() -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: self)
        return date
    }
}
