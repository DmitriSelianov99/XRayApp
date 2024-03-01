//
//  RealmManager.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 26.01.2024.
//

import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    
    private init(){}
    
    let realm = try! Realm()
    
    func addModel(_ model: PatientModel){
        try! realm.write {
            realm.add(model)
        }
    }
    
    func updateModel(_ model: PatientModel, image: Data) {
        try! realm.write {
            model.xrayPhoto = image
        }
    }
    
    func getModels() -> Results<PatientModel> {
        realm.objects(PatientModel.self)
    }
    
    func deleteModel(model: PatientModel) {
        try! realm.write {
            realm.delete(model)
        }
    }
    
    func deleteXray(model: PatientModel) {
        try! realm.write {
            model.xrayPhoto = nil
        }
    }
    
//MARK: - LOGIN
    func getDoctors() -> Results<DoctorModel> {
        realm.objects(DoctorModel.self)
    }
    
}
