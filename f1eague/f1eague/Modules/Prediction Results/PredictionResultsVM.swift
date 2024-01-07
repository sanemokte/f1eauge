//
//  PredictionResultsVM.swift
//  f1eague
//
//  Created by Sanem Ökte on 7.01.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol PredictionResultsProcotol {
    var numberOfRows: Int { get }
    func getMyPredictions() -> [String]
    func getDriver(at indexPath: IndexPath) -> String
    func getScore() -> Int
}

final class PredictionResultsVM: PredictionResultsProcotol {
    private var allDrivers: [String] = []
    private let shuffledDrivers: [String]!
    private var myPredictions: [String] = []
    private let firestoreDatabase = Firestore.firestore()
    
    init(allDrivers: [String], myPredictions: [String]) {
        self.allDrivers = allDrivers
        self.myPredictions = myPredictions
        
        shuffledDrivers = allDrivers.shuffled()
    }
    
    var numberOfRows: Int {
        return myPredictions.count
    }
    
    func getMyPredictions() -> [String] {
        return myPredictions
    }
    
    func getDriver(at indexPath: IndexPath) -> String {
        shuffledDrivers[indexPath.row]
    }
    
    func getScore() -> Int {
        var score = 0
        for i in 0..<shuffledDrivers.count {
            if myPredictions[i] == shuffledDrivers[i] {
                score += 1
            }
        }
        
        setNewScore(score)
        
        return score
    }
    
    private func setNewScore(_ score: Int) {
        firestoreDatabase.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email ?? "").getDocuments { [weak self] snapshot, error in
            if error != nil {
                print("Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let storedScore = document.get("point") as? Int {
                            let newScore = storedScore + score
                            self?.updateUserScore(newScore)
                        }
                    }
                }
            }
        }
    }
    
    private func updateUserScore(_ score: Int) {
        firestoreDatabase.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email ?? "").getDocuments { snapshot, error in
            if let error {
                print(error.localizedDescription)
            } else {
                guard let snapshot,
                      let document = snapshot.documents.first else { return }
                
                document.reference.updateData(["point": score])
            }
        }
    }
}
