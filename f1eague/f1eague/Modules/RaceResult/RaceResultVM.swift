//
//  RaceResultVM.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import Foundation

protocol RaceResultVMDelegate: AnyObject {
    func OnSuccess()
    func OnError(_ message: String?)
    func showLoading()
    func hideLoading()
    func reloadRacePickerView()
}

protocol RaceResultVMProtocol {
    var delegate: RaceResultVMDelegate? { get set }
    var numberOfRows: Int { get }
    var selectedRaceId: String { get set }
    var selectedRaceYear: String { get set }
    var raceNames: [String] { get set }
    func item(at indexPath: IndexPath) -> RaceResultVM.DataSource
    func fetchData(year: String, raceId: String)
    func fetchRaceSchedule(year: String)
}

final class RaceResultVM: RaceResultVMProtocol {
       
    // MARK: - Parameters
    private let networkManager = NetworkManager()
    private var dataSource: [DataSource] = []

    enum DataSource {
        case raceSchedule(Race)
        case raceResult(RaceResult)
        case empty
    }

    // MARK: - Protocol Parameters
    weak var delegate: RaceResultVMDelegate?
    var numberOfRows: Int {
        return dataSource.count
    }
    
    var raceNames: [String] = []
    
    var selectedRaceId: String = "1"
//        didSet {
//            fetchData(year: selectedRaceYear, raceId: selectedRaceId)
//        }
//    }
    
    var selectedRaceYear: String = "2023"
//        didSet {
//            fetchData(year: selectedRaceYear, raceId: selectedRaceId)
//        }
//    }

    
    // MARK: - Protocol Methods
    func item(at indexPath: IndexPath) -> DataSource {
        return dataSource[indexPath.row]
    }
    
    func fetchData(year: String, raceId: String) {
        delegate?.showLoading()
        networkManager.getRaceResult(year: year, raceNumber: raceId) { [weak self] result in
            self?.delegate?.hideLoading()
            guard let self else { return }
            switch result {
            case .success(let model):
                guard let races = model.mrData?.raceTable?.races, let results = races.first?.results else { return }
                dataSource.removeAll()
                for result in results {
                    dataSource.append(.raceResult(result))
                }
                delegate?.OnSuccess()
            case .failure(let failure):
                delegate?.OnError(failure.localizedDescription)
            }
        }
    }
    
    func fetchRaceSchedule(year: String) {
        delegate?.showLoading()
        networkManager.getRaceSchedule(year: year) { [weak self] result in
            self?.delegate?.hideLoading()
            guard let self else { return }
            switch result {
            case .success(let model):
                guard let races = model.mrData?.raceTable?.races else { return }
                raceNames = []
                for race in races {
                    raceNames.append(race.raceName ?? "")
                }
                self.delegate?.reloadRacePickerView()
            case .failure(let failure):
                delegate?.OnError(failure.localizedDescription)
            }
        }
    }
    
}
