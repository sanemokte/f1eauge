//
//  RaceResultResponseModel.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import Foundation

// MARK: - RaceResultResponseModel
struct RaceResultResponseModel: Codable {
    let mrData: RaceResultMRData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - RaceResultMRData
struct RaceResultMRData: Codable {
    let xmlns: String?
    let series: String?
    let url: String?
    let limit, offset, total: String?
    let raceTable: RaceResultRaceTable?

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct RaceResultRaceTable: Codable {
    let season, round: String?
    let races: [RaceResultRace]?

    enum CodingKeys: String, CodingKey {
        case season, round
        case races = "Races"
    }
}

// MARK: - Race
struct RaceResultRace: Codable {
    let season, round: String?
    let url: String?
    let raceName: String?
    let circuit: Circuit?
    let date, time: String?
    let results: [RaceResult]?

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case results = "Results"
    }
}

// MARK: - Result
struct RaceResult: Codable {
    let number, position, positionText, points: String?
    let driver: Driver?
    let constructor: Constructor?
    let grid, laps, status: String?
    let time: ResultTime?
    let fastestLap: FastestLap?

    enum CodingKeys: String, CodingKey {
        case number, position, positionText, points
        case driver = "Driver"
        case constructor = "Constructor"
        case grid, laps, status
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}

// MARK: - Constructor
struct Constructor: Codable {
    let constructorID: String?
    let url: String?
    let name, nationality: String?

    enum CodingKeys: String, CodingKey {
        case constructorID = "constructorId"
        case url, name, nationality
    }
}

// MARK: - Driver
struct Driver: Codable {
    let driverID, permanentNumber, code: String?
    let url: String?
    let givenName, familyName, dateOfBirth, nationality: String?

    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case permanentNumber, code, url, givenName, familyName, dateOfBirth, nationality
    }
}


// MARK: - FastestLap
struct FastestLap: Codable {
    let rank, lap: String?
    let time: FastestLapTime?
    let averageSpeed: AverageSpeed?

    enum CodingKeys: String, CodingKey {
        case rank, lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

// MARK: - AverageSpeed
struct AverageSpeed: Codable {
    let units: Units?
    let speed: String?
}

enum Units: String, Codable {
    case kph = "kph"
}

// MARK: - FastestLapTime
struct FastestLapTime: Codable {
    let time: String?
}

// MARK: - ResultTime
struct ResultTime: Codable {
    let millis, time: String?
}
