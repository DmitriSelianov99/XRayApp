//
//  MainViewController.swift
//  XRayApp
//
//  Created by Дмитрий Сельянов on 25.01.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private var patientsArray = [PatientModel]()
    private var refresh = UIRefreshControl() // на всякий случай, если не обновится страница
    
//MARK: - ELEMENTS
    private let headerLabel = UILabel(forHeader: "Пациенты")
    
    private let patientsCollectionView = PatientsCollectionView()
    
//MARK: - FUNCTIONS
    private func getPatients(){
        let array = RealmManager.shared.getModels()
        //patientsArray = array.map { $0 }
        
        let userDef = UserDefaults.standard.string(forKey: "userId")!
        let predicateFilter = NSPredicate(format: "doctorId= %@", userDef)
        //let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateFilter])
        
        var filteredArray = array.filter(predicateFilter)
        patientsArray = filteredArray.map { $0 }
        
        patientsCollectionView.setPatientsArray(array: patientsArray)
        patientsCollectionView.reloadData()
    }

//MARK: - CONFIG FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        
        getPatients()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPatients()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(patientsCollectionView)
        
        
        
        refresh.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        refresh.tintColor = .specialBlue
        patientsCollectionView.addSubview(refresh)
        
        patientsCollectionView.deletePatientDelegate = self
    }
    
//MARK: - objc
    @objc private func refreshCollection(){
        getPatients()
        refresh.endRefreshing()
    }
}

//MARK: - EXTENSIONS
extension MainViewController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            patientsCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 40),
            patientsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            patientsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            patientsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
        ])
    }
}

extension MainViewController: PatientCollectionViewProtocol {
    func deletePatient(model: PatientModel) {
        RealmManager.shared.deleteModel(model: model)
        getPatients()
    }
}

extension MainViewController: PatientsCollectionViewCellProtocol {
    func deleteModel(model: PatientModel) {
        RealmManager.shared.deleteModel(model: model)
        getPatients()
    }
    
    func detailedButtonTapped(model: PatientModel) {
        let detailedVC = DetailedInfoViewController()
        detailedVC.setModel(model: model)
        detailedVC.modalPresentationStyle = .fullScreen
        present(detailedVC, animated: true)
    }
    
    
}
