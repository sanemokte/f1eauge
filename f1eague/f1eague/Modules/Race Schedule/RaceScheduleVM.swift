//
//  RaceScheduleVM.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import Foundation

protocol RaceScheduleVMDelegate: AnyObject {
    func raceScheduleOnSuccess()
    func raceScheduleOnError(_ message: String?)
    func showLoading()
    func hideLoading()
}

protocol RaceScheduleVMProtocol {
    var delegate: RaceScheduleVMDelegate? { get set }
    var numberOfRows: Int { get }
    var selectedRaceYear: String { get set }
    func item(at indexPath: IndexPath) -> RaceScheduleVM.DataSource
    func fetchData(year: String)
}

final class RaceScheduleVM: RaceScheduleVMProtocol {
    // MARK: - Parameters
    private let networkManager = NetworkManager()
    private var dataSource: [DataSource] = []
    
    enum DataSource {
        case raceSchedule(Race)
        case raceResult(RaceResult)
        case empty
    }

    // MARK: - Protocol Parameters
    weak var delegate: RaceScheduleVMDelegate?
    var numberOfRows: Int {
        return dataSource.count
    }
    
    var selectedRaceYear: String = "2023" {
        didSet {
            fetchData(year: selectedRaceYear)
        }
    }
    
    // MARK: - Protocol Methods
    func item(at indexPath: IndexPath) -> DataSource {
        return dataSource[indexPath.row]
    }
    
    func fetchData(year: String) {
        delegate?.showLoading()
        networkManager.getRaceSchedule(year: year) { [weak self] result in
            self?.delegate?.hideLoading()
            guard let self else { return }
            switch result {
            case .success(let model):
                guard let races = model.mrData?.raceTable?.races else { return }
                dataSource.removeAll()
                for race in races {
                    dataSource.append(.raceSchedule(race))
                }
                delegate?.raceScheduleOnSuccess()
            case .failure(let failure):
                delegate?.raceScheduleOnError(failure.localizedDescription)
            }
        }
    }
}
