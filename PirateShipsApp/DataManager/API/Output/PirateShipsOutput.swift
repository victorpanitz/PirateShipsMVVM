//
//  PirateShipsOutput.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 14/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct PirateShipsOutput: Decodable {
    var success: Bool
    var ships: [ShipOutput?]
}
