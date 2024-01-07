//
//  ResultPredictionVM.swift
//  f1eague
//
//  Created by Sanem Ökte on 6.01.2024.
//

import Foundation
import Firebase

protocol ResultPredictionVMDelegate: AnyObject {
    func predictionOnSuccess()
    func predictionOnError(_ message: String?)
    func showLoading()
    func hideLoading()
    func setPredictionCompletedView()
}

protocol ResultPredictionVMProtocol {
    var delegate: ResultPredictionVMDelegate? { get set }
    var userLastPrediction: [String] { get set }
    var userLastPredictionRound: String { get set }
    func getAllDrivers() -> [String]
    func fetchData()
    func getLastRaceDrivers()
    func submit(prediction: [String])
    func validateRound() -> Bool
}

final class ResultPredictionVM: ResultPredictionVMProtocol {
    
    // MARK: - Parameters
    private let networkManager = NetworkManager()
    //    private var dataSource: [DataSource] = []
    private var allDrivers: [String] = []
    private var round = ""
    var userLastPrediction: [String] = []
    var userLastPredictionRound: String = ""
    private var dispatchGroup = DispatchGroup()
    
    enum DataSource {
        case driver(Driver)
        case empty
    }
    
    // MARK: - Protocol Parameters
    weak var delegate: ResultPredictionVMDelegate?
    
    //    // MARK: - Protocol Methods
    
    func getAllDrivers() -> [String] {
        allDrivers
    }
    
    func submit(prediction: [String]) {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email ?? "").getDocuments { snapshot, error in
            if error != nil {
                print("Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let updateLastPredictionRound = ["lastPredictionRound" : self.round]
                        document.reference.updateData(updateLastPredictionRound)
                        let updateLastPrediction = ["lastPrediction" : prediction]
                        document.reference.updateData(updateLastPrediction)
                    }
                    self.delegate?.setPredictionCompletedView()
                }
            }
        }
    }
    
    func fetchPredictions() {
        dispatchGroup.enter()
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email ?? "").getDocuments { snapshot, error in
            if error != nil {
                self.dispatchGroup.leave()
                print("Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let lastPrediction = document.get("lastPrediction") as? [String] {
                            self.userLastPrediction = lastPrediction
                        }
                        if let lastPredictionRound = document.get("lastPredictionRound") as? String {
                            self.userLastPredictionRound = lastPredictionRound
//                            self.userLastPredictionRound = "21"
                        }
                    }
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    func getLastRaceDrivers() {
        dispatchGroup.enter()
        networkManager.getLastRaceDrivers() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                guard let drivers = model.mrData?.driverTable?.drivers else { return }
                //                dataSource.removeAll()
                allDrivers.removeAll()
                self.round = model.mrData?.driverTable?.round ?? ""
                for driver in drivers {
                    let driverName = "\(driver.givenName ?? "") \(driver.familyName ?? "")"
                    allDrivers.append(driverName)
                }
                self.dispatchGroup.leave()
//                delegate?.predictionOnSuccess()
            case .failure(let failure):
                self.dispatchGroup.leave()
                delegate?.predictionOnError(failure.localizedDescription)
            }
        }
    }
    
    func fetchData() {
        delegate?.showLoading()
        getLastRaceDrivers()
        fetchPredictions()
        dispatchGroup.notify(queue: .main) {
            self.delegate?.hideLoading()
            if self.validateRound() {
                self.delegate?.setPredictionCompletedView()
            } else {
                self.delegate?.predictionOnSuccess()
            }
        }
    }
    
    func validateRound() -> Bool {
        if round == userLastPredictionRound {
            return true
        } else {
            return false
        }
    }
}
