//
//  PatientsCollectionView.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 25.01.2024.
//

import UIKit

protocol PatientCollectionViewProtocol: AnyObject {
    func deletePatient(model: PatientModel)
}

class PatientsCollectionView: UICollectionView {
    let collectionLayout = UICollectionViewFlowLayout()
    let idCell = "idCell"
    weak var deletePatientDelegate: PatientCollectionViewProtocol?
    
    
    private var patientArray = [PatientModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        
        configure()
        setDelegates()
        register(PatientsCollectionViewCell.self, forCellWithReuseIdentifier: idCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .none
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 0
    }
    
    private func setDelegates() {
        delegate = self
        dataSource = self
    }
    
    public func setPatientsArray(array: [PatientModel]){
        patientArray = array
    }
}

//MARK: - EXTENSIONS
extension PatientsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap")
    }
}

extension PatientsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as? PatientsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.numOfCell = indexPath.row
        cell.configure(model: patientArray[indexPath.row])
        cell.patientDelegate = deletePatientDelegate as? PatientsCollectionViewCellProtocol
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        patientArray.count
    }
}

extension PatientsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 205)
    }
    
}

