//
//  PatientModel.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 26.01.2024.
//

import RealmSwift
import Foundation

class PatientModel: Object {
    @Persisted var name: String
    @Persisted var sex: Bool
    @Persisted var birthday: Date
    @Persisted var visitDate: Date
    @Persisted var xrayPhoto: Data?
    @Persisted var doctorId: String
}
