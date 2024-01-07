//
//  DriverStandingsResponseModel.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import Foundation

// MARK: - DriverStandingsResponseModel
struct DriverStandingsResponseModel: Codable {
    let mrData: DriverStandingsMRData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct DriverStandingsMRData: Codable {
    let xmlns: String?
    let series: String?
    let url: String?
    let limit, offset, total: String?
    let standingsTable: StandingsTable?

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case standingsTable = "StandingsTable"
    }
}

// MARK: - StandingsTable
struct StandingsTable: Codable {
    let season: String?
    let standingsLists: [StandingsList]?

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

// MARK: - StandingsList
struct StandingsList: Codable {
    let season, round: String?
    let driverStandings: [DriverStanding]?

    enum CodingKeys: String, CodingKey {
        case season, round
        case driverStandings = "DriverStandings"
    }
}

// MARK: - DriverStanding
struct DriverStanding: Codable {
    let position, positionText, points, wins: String?
    let driver: Driver?
    let constructors: [Constructor]?

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins
        case driver = "Driver"
        case constructors = "Constructors"
    }
}
