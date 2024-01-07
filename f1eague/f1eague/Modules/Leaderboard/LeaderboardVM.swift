//
//  LeaderboardVM.swift
//  f1eague
//
//  Created by Sanem Ökte on 7.01.2024.
//

import Foundation
import FirebaseFirestore

protocol LeaderboardVMDelegate: AnyObject {
    func onSuccess()
    func onError(_ message: String?)
}

protocol LeaderboardVMProtocol {
    var delegate: LeaderboardVMDelegate? { get set }
    var numberOfRows: Int { get }
    func getItem(at indexPath: IndexPath) -> LeaderboardVM.DataSource
    func fetchLeaderboard()
}

final class LeaderboardVM: LeaderboardVMProtocol {
    // MARK: - Parameters
    private var dataSource: [DataSource] = []
    
    enum DataSource {
        case competitor(Competitor)
    }
    
    // MARK: - Protocol Parameters
    weak var delegate: LeaderboardVMDelegate?
    var numberOfRows: Int {
        return dataSource.count
    }
    
    // MARK: - Protocol Methods
    func getItem(at indexPath: IndexPath) -> DataSource {
        return dataSource[indexPath.row]
    }
    
    func fetchLeaderboard() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("users").order(by: "point", descending: true).getDocuments { [weak self] snapshot, error in
            guard let self else { return }
            if let error {
                print(error.localizedDescription)
            } else {
                guard let documents = snapshot?.documents else { return }
                for document in documents {
                    do {
                        let competitor = try document.data(as: Competitor.self)
                        dataSource.append(.competitor(competitor))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                delegate?.onSuccess()
            }
        }
    }
}
