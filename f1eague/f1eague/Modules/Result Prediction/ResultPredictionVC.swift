//
//  ResultPredictionVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 6.01.2024.
//

import UIKit

class ResultPredictionVC: UIViewController {
    // MARK: - Parameters
    var viewModel: ResultPredictionVMProtocol = ResultPredictionVM()
    var selectedIndex: Int = -1
    var selectedDriver: String = ""
    var selectedDrivers = Array(repeating: "", count: 20)
    var allDrivers: [String] = []
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var constraintBottomPickerView: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var predictionCompletedView: UIView!
    @IBOutlet weak var btnShowResult: UIButton!
    @IBOutlet weak var viewLeaderboard: UIView!
    
    // MARK: - Actions
    @IBAction func routeToLeaderBoard(_ sender: Any) {
        guard let leaderboardVC = UIStoryboard(
                name: "Leaderboard",
                bundle: nil
        ).instantiateViewController(
            withIdentifier: "LeaderboardVC"
        ) as? LeaderboardVC else { return }
        leaderboardVC.viewModel = LeaderboardVM()
        present(leaderboardVC, animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        viewModel.submit(prediction: selectedDrivers)
    }
    
    @IBAction func btnSeeResults(_ sender: Any) {
        let allDrivers = viewModel.getAllDrivers()
        guard let predictionResultsVC = UIStoryboard(
            name: "PredictionResults",
            bundle: nil).instantiateViewController(
                withIdentifier: "PredictionResultsVC"
            ) as? PredictionResultsVC else { return }
        predictionResultsVC.viewModel = PredictionResultsVM(
            allDrivers: allDrivers,
            myPredictions: viewModel.userLastPrediction
        )
        present(predictionResultsVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
}

// MARK: - Private Functions
extension ResultPredictionVC {
    private func initVC() {
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ResultPredictionTbVCell.self)
        pickerView.delegate = self
        pickerView.dataSource = self
        btnSubmit.layer.borderWidth = 2
        btnSubmit.layer.borderColor = UIColor.black.cgColor
        btnSubmit.isUserInteractionEnabled = false
        btnSubmit.alpha = 0.6
        btnSubmit.layer.cornerRadius = 8
        btnSubmit.clipsToBounds = true
        predictionCompletedView.layer.borderColor = UIColor.white.cgColor
        predictionCompletedView.layer.borderWidth = 2
        predictionCompletedView.layer.cornerRadius = 20
        predictionCompletedView.clipsToBounds = true
        btnShowResult.layer.borderColor = UIColor.systemRed.cgColor
        btnShowResult.layer.borderWidth = 1
        viewLeaderboard.layer.borderColor = UIColor.systemGray3.cgColor
        viewLeaderboard.layer.borderWidth = 2
        viewModel.fetchData()
    }
    
    private func showPickerYear() {
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
        tableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomPickerView.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    private func hidePickerYear() {
        pickerView.isHidden = true
        tableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomPickerView.constant = -200
            view.layoutIfNeeded()
        }
    }
    
    private func validateSubmit() {
        var isThereEmptyElement = false
        for item in selectedDrivers {
            if item.isEmpty {
                isThereEmptyElement = true
                break
            }
        }
        if isThereEmptyElement {
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.alpha = 0.6
        } else {
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.alpha = 1
        }
    }
}

// MARK: - ResultPredictionVMDelegate Functions
extension ResultPredictionVC: ResultPredictionVMDelegate{
    func predictionOnSuccess() {
        allDrivers = viewModel.getAllDrivers()
        tableView.isHidden = false
        btnSubmit.isHidden = false
        predictionCompletedView.isHidden = true
        lblTitle.isHidden = false
    }
    
    func predictionOnError(_ message: String?) {
        print(message ?? "")
    }
    
    func showLoading() {
        Loading.show()
    }
    
    func hideLoading() {
        Loading.hide()
    }
    
    func setPredictionCompletedView() {
        allDrivers = viewModel.getAllDrivers()
        predictionCompletedView.isHidden = false
        tableView.isHidden = true
        btnSubmit.isHidden = true
        lblTitle.isHidden = true
    }
}


// MARK: - UITableView Methods
extension ResultPredictionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDrivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ResultPredictionTbVCell.self, for: indexPath)
        cell.setCell(index: indexPath.row, driverName: selectedDrivers[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !selectedDrivers[indexPath.row].isEmpty {
            allDrivers.append(selectedDrivers[indexPath.row])
        }
        selectedIndex = indexPath.row
        showPickerYear()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

// MARK: UIPickerView Methods
extension ResultPredictionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDrivers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allDrivers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDriver = allDrivers[row]
        allDrivers.remove(at: row)
        selectedDrivers[selectedIndex] = selectedDriver
        validateSubmit()
        tableView.reloadData()
        hidePickerYear()
    }
}

//// MARK: - UIScrollView Delegate
//extension ResultPredictionVC: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        hidePickerYear()
//    }
//}
