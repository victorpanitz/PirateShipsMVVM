//
//  ShipOutput.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 14/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct ShipOutput: Decodable {
    var id: Int
    var title: String?
    var image: String?
    var detail: String?
    var type: String?
    var price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case image
        case detail = "description"
        case type = "greeting_type"
    }
}
