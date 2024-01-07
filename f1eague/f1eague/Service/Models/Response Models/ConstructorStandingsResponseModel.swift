//
//  ConstructorStandingsResponseModel.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import Foundation

// MARK: - ConstructorStandingsResponseModel
struct ConstructorStandingsResponseModel: Codable {
    let mrData: ConstructorStandingsMRData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct ConstructorStandingsMRData: Codable {
    let xmlns: String?
    let series: String?
    let url: String?
    let limit, offset, total: String?
    let standingsTable: ConstructorStandingsStandingsTable?

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case standingsTable = "StandingsTable"
    }
}

// MARK: - StandingsTable
struct ConstructorStandingsStandingsTable: Codable {
    let season: String?
    let standingsLists: [ConstructorStandingsStandingsList]?

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

// MARK: - StandingsList
struct ConstructorStandingsStandingsList: Codable {
    let season, round: String?
    let constructorStandings: [ConstructorStanding]?

    enum CodingKeys: String, CodingKey {
        case season, round
        case constructorStandings = "ConstructorStandings"
    }
}

// MARK: - ConstructorStanding
struct ConstructorStanding: Codable {
    let position, positionText, points, wins: String?
    let constructor: Constructor?

    enum CodingKeys: String, CodingKey {
        case position, positionText, points, wins
        case constructor = "Constructor"
    }
}
