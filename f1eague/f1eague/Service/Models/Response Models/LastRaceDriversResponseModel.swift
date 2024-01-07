//
//  LastRaceDriversResponseModel.swift
//  f1eague
//
//  Created by Sanem Ökte on 6.01.2024.
//

import Foundation

// MARK: - LastRaceDriversResponseModel
struct LastRaceDriversResponseModel: Codable {
    let mrData: LastRaceDriversMRData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct LastRaceDriversMRData: Codable {
    let xmlns: String?
    let series: String?
    let url: String?
    let limit, offset, total: String?
    let driverTable: DriverTable?

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case driverTable = "DriverTable"
    }
}

// MARK: - DriverTable
struct DriverTable: Codable {
    let season, round: String?
    let drivers: [Driver]?

    enum CodingKeys: String, CodingKey {
        case season, round
        case drivers = "Drivers"
    }
}
