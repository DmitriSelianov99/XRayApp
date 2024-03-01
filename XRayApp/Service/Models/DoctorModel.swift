//
//  DoctorModel.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 06.02.2024.
//

import RealmSwift

class DoctorModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var login: String
    @Persisted var password: String
}
