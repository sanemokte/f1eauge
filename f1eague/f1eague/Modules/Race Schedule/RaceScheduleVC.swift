//
//  NewsVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import UIKit

class RaceScheduleVC: UIViewController {
    // MARK: - Parameters
    var viewModel: RaceScheduleVMProtocol = RaceScheduleVM()
    let startYear = 1950
    var raceYears: [String] = []

    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var constraintBottomPickerView: NSLayoutConstraint!
    @IBOutlet weak var viewYearSelection: UIView!
    
    // MARK: - Actions
    @IBAction func openYearPickerView(_ sender: Any) {
        showPickerYear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        self.becomeFirstResponder()
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
extension RaceScheduleVC {
    private func initVC() {
        viewModel.delegate = self
        
        viewYearSelection.layer.borderColor = UIColor.systemGray3.cgColor
        viewYearSelection.layer.borderWidth = 2
        
        tableView.register(cellType: RaceScheduleTbVCell.self)
        
        raceYears = makeYearsArray(from: startYear)
        viewModel.fetchData(year: viewModel.selectedRaceYear)
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
    }
    
    func showPickerYear() {
        yearPickerView.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomPickerView.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    func hidePickerYear() {
        yearPickerView.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomPickerView.constant = -200
            view.layoutIfNeeded()
        }
    }
    
}

// MARK: - RaceScheduleVM Delegate
extension RaceScheduleVC: RaceScheduleVMDelegate {
    func raceScheduleOnError(_ message: String?) {
        print(message ?? "")
    }
    
    func raceScheduleOnSuccess() {
        tableView.reloadData()
    }
    
    func showLoading() {
        Loading.show()
    }
    
    func hideLoading() {
        Loading.hide()
    }
}

// MARK: - UITableView Methods
extension RaceScheduleVC: UITableViewDelegate, UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(with: RaceScheduleTbVCell.self, for: indexPath)
            cell.setResults(with: race)
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.textLabel?.text = "BOŞ"
            cell.backgroundColor = .yellow
            return cell
        }
    }
}

// MARK: UIPickerView Methods
extension RaceScheduleVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return raceYears.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return raceYears[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lblYear.text = raceYears[row] + " Season"
        if viewModel.selectedRaceYear != raceYears[row] {
            viewModel.selectedRaceYear = raceYears[row]
//            viewModel.fetchData(year: viewModel.selectedRaceYear)
        }
        hidePickerYear()
    }
}

// MARK: - UIScrollView Delegate
extension RaceScheduleVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hidePickerYear()
    }
}
