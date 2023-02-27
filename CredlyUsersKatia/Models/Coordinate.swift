//
//  Coordinate.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import Foundation

struct Coordinate: Codable, Equatable {
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
