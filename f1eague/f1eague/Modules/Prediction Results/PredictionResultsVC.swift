//
//  PredictionResultsVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 7.01.2024.
//

import UIKit

class PredictionResultsVC: UIViewController {
    var viewModel: PredictionResultsVM!

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var lblScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVC()
    }
    
}

// MARK: - Private Functions
extension PredictionResultsVC {
    private func initVC() {
        tableView.register(cellType: ResultPredictionTbVCell.self)
        
        lblScore.layer.borderColor = UIColor.systemGray3.cgColor
        lblScore.layer.borderWidth = 2
        
        setScore()
    }
    
    private func setScore() {
        lblScore.text = "Score: \(viewModel.getScore())"
    }
}

// MARK: - UITableView Methods
extension PredictionResultsVC: UITableViewDelegate,
                              UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let driverName = viewModel.getMyPredictions()[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: ResultPredictionTbVCell.self, for: indexPath)
        cell.setResult(
            index: indexPath.row,
            predictedDriver: driverName,
            driver: viewModel.getDriver(at: indexPath)
        )
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
