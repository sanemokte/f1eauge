//
//  RaceResultVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 23.12.2023.
//

import UIKit
import Firebase

class RaceResultVC: UIViewController {
    
    // MARK: - Parameters
    var viewModel: RaceResultVMProtocol = RaceResultVM()
    var gridNo: Int?
    var driverName: String?
    var constructorLogoUrl: String?
    var constructorName: String?
//    var raceNames: [String] = ["Bahrain", "Saudi", "Australian", "Azerbaijan", "Miami"]
    let startYear = 1950
    var raceYears: [String] = []

    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblRaceName: UILabel!
    @IBOutlet weak var raceIdView: UIView!
    @IBOutlet weak var btnRaceIdView: UIButton!
    @IBOutlet weak var lblRaceYear: UILabel!
    @IBOutlet weak var raceYearView: UIView!
    @IBOutlet weak var btnRaceYearView: UIButton!
    @IBOutlet weak var raceNamePickerView: UIPickerView!
    @IBOutlet weak var constraintBottomPicker: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomYearPicker: NSLayoutConstraint!
    @IBOutlet weak var raceYearPickerView: UIPickerView!
    @IBOutlet weak var btnSearchRace: UIButton!
    @IBOutlet weak var viewYearSelection: UIView!
    @IBOutlet weak var viewRaceSelection: UIView!
    
    // MARK: - Actions
    @IBAction func openPickerYear(_ sender: Any) {
        showPickerYear()
    }
    
    @IBAction func openPickerRace(_ sender: Any) {
        showPickerRace()
    }
    
    @IBAction func searchRaceResult(_ sender: Any) {
        viewModel.fetchData(year: viewModel.selectedRaceYear, raceId: viewModel.selectedRaceId)
        hidePickerRace()
        hidePickerYear()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        initVC()
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            showPickerYear()
        }
    }
}

// MARK: - Methods
extension RaceResultVC {
    private func initVC() {
        viewModel.delegate = self
        
        viewRaceSelection.layer.borderColor = UIColor.systemGray3.cgColor
        viewYearSelection.layer.borderColor = UIColor.systemGray3.cgColor
        viewRaceSelection.layer.borderWidth = 2
        viewYearSelection.layer.borderWidth = 2
        
        tableView.register(cellType: RaceResultTbVCell.self)
        
        raceYears = makeYearsArray(from: startYear)
        
        viewModel.fetchRaceSchedule(year: viewModel.selectedRaceYear)
        viewModel.fetchData(year: viewModel.selectedRaceYear, raceId: viewModel.selectedRaceId)
        
        raceNamePickerView.delegate = self
        raceNamePickerView.dataSource = self
        raceYearPickerView.delegate = self
        raceYearPickerView.dataSource = self
    }
    
    func showPickerYear() {
        raceYearPickerView.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomYearPicker.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    func hidePickerYear() {
        raceYearPickerView.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomYearPicker.constant = -200
            view.layoutIfNeeded()
        }
    }
    
    func showPickerRace() {
        raceYearPickerView.reloadAllComponents()
        raceNamePickerView.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomPicker.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    func hidePickerRace() {
        raceNamePickerView.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomPicker.constant = -200
            view.layoutIfNeeded()
        }
    }
}

// MARK: - RaceResultVM Delegate
extension RaceResultVC: RaceResultVMDelegate {
    func OnError(_ message: String?) {
        print(message ?? "")
    }
    
    func OnSuccess() {
        tableView.reloadData()
    }
    
    func showLoading() {
        Loading.show()
    }
    
    func hideLoading() {
        Loading.hide()
    }
    
    func reloadRacePickerView() {
        raceNamePickerView.reloadAllComponents()
    }
}

// MARK: - UITableView Methods
extension RaceResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath)
        
        switch item {
        case .raceSchedule(let race):
            let cell = tableView.dequeueReusableCell(with: RaceScheduleTbVCell.self, for: indexPath)
            cell.set(with: race)
            return cell
        case .raceResult(let race):
            let cell = tableView.dequeueReusableCell(with: RaceResultTbVCell.self, for: indexPath)
            cell.setResults(with: race)
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.textLabel?.text = "BOŞ"
            cell.backgroundColor = .yellow
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}


// MARK: UIPickerView Methods
extension RaceResultVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == raceNamePickerView {
            return viewModel.raceNames.count
        } else if pickerView == raceYearPickerView {
            return raceYears.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == raceNamePickerView {
            return viewModel.raceNames[row]
        } else if pickerView == raceYearPickerView {
            return raceYears[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == raceNamePickerView {
            lblRaceName.text = viewModel.raceNames[row]
            if viewModel.selectedRaceId != String(row + 1) {
                viewModel.selectedRaceId = String(row + 1)
                btnSearchRace.isEnabled = true
                btnSearchRace.alpha = 1
            }
            hidePickerRace()
        } else if pickerView == raceYearPickerView {
            lblRaceYear.text = raceYears[row] + " Season"
            if viewModel.selectedRaceYear != raceYears[row] {
                viewModel.selectedRaceYear = raceYears[row]
                lblRaceName.text = "Please Select A Race"
                btnSearchRace.isEnabled = false
                btnSearchRace.alpha = 0.6
                viewModel.fetchRaceSchedule(year: viewModel.selectedRaceYear)
            }
            hidePickerYear()
        }
    }
}

// MARK: - UIScrollView Delegate
extension RaceResultVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hidePickerRace()
        hidePickerYear()
    }
}
