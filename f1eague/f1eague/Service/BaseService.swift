//
//  BaseService.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import Foundation
import Moya

enum BaseService {
    case raceSchedule(_ year: String)
    case raceResult(_ year: String, _ raceNumber: String)
    case driverStandings(_ year: String)
    case constructorStandings(_ year: String)
    case getLastRaceDrivers
}

extension BaseService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .raceSchedule(let year):
            return "/f1/\(year).json"
        case .raceResult(let year, let raceNumber):
            return "/f1/\(year)/\(raceNumber)/results.json"
        case .driverStandings(let year):
            return "/f1/\(year)/driverStandings.json"
        case .constructorStandings(let year):
            return "/f1/\(year)/constructorStandings.json"
        case .getLastRaceDrivers:
            return "/f1/current/last/drivers.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .raceSchedule, .raceResult, .driverStandings, .constructorStandings, .getLastRaceDrivers:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .raceSchedule, .raceResult, .driverStandings, .constructorStandings, .getLastRaceDrivers:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
