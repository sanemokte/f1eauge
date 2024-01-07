//
//  StandingsVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import UIKit

enum StandingTab {
    case drivers
    case constructors
}

class StandingsVC: UIViewController {
    
    // MARK: - Parameters
    var viewModel: StandingsVMProtocol = StandingsVM()
    var selectedTab: StandingTab = .drivers
    let startYear = 1950
    var raceYears: [String] = []

    // MARK: - Outlets
    @IBOutlet weak var driversTableView: UITableView!
    @IBOutlet weak var constructorsTableView: UITableView!
    @IBOutlet weak var btnDrivers: UIButton!
    @IBOutlet weak var btnConstructors: UIButton!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var constraintBottomYearPicker: NSLayoutConstraint!
    @IBOutlet weak var viewTabSelection: UIView!
    @IBOutlet weak var viewYearSelection: UIView!
        
    // MARK: - Actions
    @IBAction func showDriverStandings(_ sender: Any) {
        selectedTab = .drivers
        driversTableView.isHidden = false
        constructorsTableView.isHidden = true
        btnDrivers.titleLabel?.font = UIFont(name: "Formula1 Display-Bold Bold", size: 15)
        btnConstructors.titleLabel?.font = UIFont(name: "Formula1 Display-Regular", size: 15)
        btnDrivers.alpha = 1
        btnConstructors.alpha = 0.6
    }
    
    @IBAction func showConstructorsStandings(_ sender: Any) {
        selectedTab = .constructors
        constructorsTableView.isHidden = false
        driversTableView.isHidden = true
        btnConstructors.titleLabel?.font = UIFont(name: "Formula1 Display-Bold Bold", size: 15)
        btnDrivers.titleLabel?.font = UIFont(name: "Formula1 Display-Regular", size: 15)
        btnDrivers.alpha = 0.6
        btnConstructors.alpha = 1
    }
    
    @IBAction func openYearPicker(_ sender: Any) {
        showPickerYear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        self.becomeFirstResponder()
        driversTableView.isHidden = false
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

extension StandingsVC {
    private func initVC() {
        viewModel.delegate = self
        
        viewTabSelection.layer.borderColor = UIColor.systemGray3.cgColor
        viewYearSelection.layer.borderColor = UIColor.systemGray3.cgColor
        viewTabSelection.layer.borderWidth = 2
        viewYearSelection.layer.borderWidth = 2
        
        driversTableView.delegate = self
        driversTableView.dataSource = self
        driversTableView.register(cellType: DriversStandingsTbVCell.self)
        
        constructorsTableView.delegate = self
        constructorsTableView.dataSource = self
        constructorsTableView.register(cellType: ConstructorsStandingsTbVCell.self)
        
        raceYears = makeYearsArray(from: startYear)
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        viewModel.selectedRaceYear = "2023"
//        viewModel.fetchDriverStandingsData(year: "2023")
//        viewModel.fetchConstructorsStandingsData(year: "2023")
    }
    
    func showPickerYear() {
        yearPickerView.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomYearPicker.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    func hidePickerYear() {
        yearPickerView.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            constraintBottomYearPicker.constant = -200
            view.layoutIfNeeded()
        }
    }
}

// MARK: - RaceResultVM Delegate
extension StandingsVC: StandingsVMDelegate {
    func OnSuccess() {
        driversTableView.reloadData()
        constructorsTableView.reloadData()
    }
    
    func OnError(_ message: String?) {
        print(message ?? "")
    }
    
    func showLoading() {
        Loading.show()
    }
    
    func hideLoading() {
        Loading.hide()
    }
}

// MARK: - UITableView Methods
extension StandingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == driversTableView {
            return viewModel.driverNumberOfRows
        } else {
            return viewModel.constructorsNumberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == driversTableView {
            let itemDriver = viewModel.itemDrivers(at: indexPath)
            
            switch itemDriver {
            case .driverStandings(let driver):
                let cell = tableView.dequeueReusableCell(with: DriversStandingsTbVCell.self, for: indexPath)
                cell.setResults(with: driver)
                cell.selectionStyle = .none
                return cell
            case .constructorStandings(let constructor):
                let cell = tableView.dequeueReusableCell(with: ConstructorsStandingsTbVCell.self, for: indexPath)
                cell.setResults(with: constructor)
                return cell
            }
        } else {
            let itemConstructor = viewModel.itemConstructors(at: indexPath)
            
            switch itemConstructor {
            case .driverStandings(let driver):
                let cell = tableView.dequeueReusableCell(with: DriversStandingsTbVCell.self, for: indexPath)
                cell.setResults(with: driver)
                cell.selectionStyle = .none
                return cell
            case .constructorStandings(let constructor):
                let cell = tableView.dequeueReusableCell(with: ConstructorsStandingsTbVCell.self, for: indexPath)
                cell.setResults(with: constructor)
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}


// MARK: UIPickerView Methods
extension StandingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
extension StandingsVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hidePickerYear()
    }
}
