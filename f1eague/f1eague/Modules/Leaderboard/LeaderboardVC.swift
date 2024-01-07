//
//  LeaderboardVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 7.01.2024.
//

import UIKit

class LeaderboardVC: UIViewController {
    // MARK: - Parameters
    var viewModel: LeaderboardVMProtocol!
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var viewLeaderboard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVC()
    }
    
}

// MARK: - Methods
extension LeaderboardVC {
    private func initVC() {
        tableView.register(cellType: ResultPredictionTbVCell.self)
        
        viewModel.delegate = self
        
        viewLeaderboard.layer.borderColor = UIColor.white.cgColor
        viewLeaderboard.layer.borderWidth = 1
        
        viewModel.fetchLeaderboard()
    }
}

// MARK: - LeaderboardVM Delegate
extension LeaderboardVC: LeaderboardVMDelegate {
    func onSuccess() {
        tableView.reloadData()
    }
    
    func onError(_ message: String?) {
        print(message as Any)
    }
}

// MARK: - UITableView Methods
extension LeaderboardVC: UITableViewDelegate,
                         UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getItem(at: indexPath)
        
        switch item {
        case .competitor(let competitor):
            let cell = tableView.dequeueReusableCell(with: ResultPredictionTbVCell.self, for: indexPath)
            cell.setCell(
                index: indexPath.row,
                driverName: competitor.username,
                score: competitor.point
            )
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
