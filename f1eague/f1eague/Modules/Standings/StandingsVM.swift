//
//  StandingsVM.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import Foundation

protocol StandingsVMDelegate: AnyObject {
    func OnSuccess()
    func OnError(_ message: String?)
    func showLoading()
    func hideLoading()
}

protocol StandingsVMProtocol {
    var delegate: StandingsVMDelegate? { get set }
    var driverNumberOfRows: Int { get }
    var constructorsNumberOfRows: Int { get }
    var selectedRaceYear: String { get set }
    func itemDrivers(at indexPath: IndexPath) -> StandingsVM.DataSource
    func itemConstructors(at indexPath: IndexPath) -> StandingsVM.DataSource
    func fetchDriverStandingsData(year: String)
    func fetchConstructorsStandingsData(year: String)
}

final class StandingsVM: StandingsVMProtocol {

    // MARK: - Parameters
    private let networkManager = NetworkManager()
    private var driverDataSource: [DataSource] = []
    private var constructorsDataSource: [DataSource] = []
    private let dispatchGroup = DispatchGroup()
    
    enum DataSource {
        case driverStandings(DriverStanding)
        case constructorStandings(ConstructorStanding)
    }
    
    // MARK: - Protocol Parameters
    weak var delegate: StandingsVMDelegate?
    var driverNumberOfRows: Int {
        return driverDataSource.count
    }
    
    var constructorsNumberOfRows: Int {
        return constructorsDataSource.count
    }
    
    var selectedRaceYear: String = "2023" {
        didSet {
            delegate?.showLoading()
            fetchDriverStandingsData(year: self.selectedRaceYear)
            fetchConstructorsStandingsData(year: self.selectedRaceYear)
            dispatchGroup.notify(queue: .main) {
                self.delegate?.hideLoading()
                self.delegate?.OnSuccess()
            }
        }
    }
    
    // MARK: - Protocol Methods
    
    func itemDrivers(at indexPath: IndexPath) -> DataSource {
        return driverDataSource[indexPath.row]
    }
    
    func itemConstructors(at indexPath: IndexPath) -> DataSource {
        return constructorsDataSource[indexPath.row]
    }
    
    func fetchDriverStandingsData(year: String) {
        //delegate?.showLoading()
        dispatchGroup.enter()
        networkManager.getDriverStandings(year: year) {
            [weak self] result in
                //self?.delegate?.hideLoading()
                guard let self else { return }
            switch result {
            case .success(let model):
                guard let standings = model.mrData?.standingsTable?.standingsLists?.first, let driverStandings = standings.driverStandings else { return }
                driverDataSource.removeAll()
                for driverStanding in driverStandings {
                    driverDataSource.append(.driverStandings(driverStanding))
                }
                //delegate?.OnSuccess()
                self.dispatchGroup.leave()
            case .failure(let failure):
                self.dispatchGroup.leave()
                delegate?.OnError(failure.localizedDescription)
            }
        }
    }
    
    func fetchConstructorsStandingsData(year: String) {
        //delegate?.showLoading()
        dispatchGroup.enter()
        networkManager.getConstructorStandings(year: year) {
            [weak self] result in
                //self?.delegate?.hideLoading()
                guard let self else { return }
            switch result {
            case .success(let model):
                guard let standings = model.mrData?.standingsTable?.standingsLists?.first, let constructorsStandings = standings.constructorStandings else { return }
                constructorsDataSource.removeAll()
                for constructorsStanding in constructorsStandings {
                    constructorsDataSource.append(.constructorStandings(constructorsStanding))
                }
                self.dispatchGroup.leave()
                //delegate?.OnSuccess()
            case .failure(let failure):
                dispatchGroup.leave()
                delegate?.OnError(failure.localizedDescription)
            }
        }
    }
    
}
