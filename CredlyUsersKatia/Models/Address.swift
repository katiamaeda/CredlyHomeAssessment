//
//  Address.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import Foundation

struct Address: Codable, Equatable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Coordinate
}
