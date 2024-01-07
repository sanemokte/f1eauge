//
//  NetworkManager.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import UIKit
import Moya

protocol Networkable {
    var provider: MoyaProvider<BaseService> { get }
    
    func getRaceSchedule(year: String, completion: @escaping (Result<RaceScheduleResponseModel, Error>) -> Void)
    func getRaceResult(year: String, raceNumber: String, completion: @escaping (Result<RaceResultResponseModel, Error>) -> Void)
    func getDriverStandings(year: String, completion: @escaping (Result<DriverStandingsResponseModel, Error>) -> Void)
    func getConstructorStandings(year: String, completion: @escaping (Result<ConstructorStandingsResponseModel, Error>) -> Void)
    func getLastRaceDrivers(_ completion: @escaping (Result<LastRaceDriversResponseModel, Error>) -> Void)
}

final class NetworkManager: Networkable {
    // MARK: - Protocol Parameters
    var provider: Moya.MoyaProvider<BaseService> = MoyaProvider<BaseService>()
    
    // MARK: - Protocol Methods
    func getRaceSchedule(year: String, completion: @escaping (Result<RaceScheduleResponseModel, Error>) -> Void) {
        request(target: .raceSchedule(year), completion: completion)
    }
    
    func getRaceResult(year: String, raceNumber: String, completion: @escaping (Result<RaceResultResponseModel, Error>) -> Void) {
        request(target: .raceResult(year, raceNumber), completion: completion)
    }
    
    func getDriverStandings(year: String, completion: @escaping (Result<DriverStandingsResponseModel, Error>) -> Void) {
        request(target: .driverStandings(year), completion: completion)
    }
    
    func getConstructorStandings(year: String, completion: @escaping (Result<ConstructorStandingsResponseModel, Error>) -> Void) {
        request(target: .constructorStandings(year), completion: completion)
    }
    
    func getLastRaceDrivers(_ completion: @escaping (Result<LastRaceDriversResponseModel, Error>) -> Void) {
        request(target: .getLastRaceDrivers, completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: BaseService, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
