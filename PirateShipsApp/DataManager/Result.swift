//
//  Result.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

public enum Result<T> {
    case succeeded(_ value: T)
    case failed(_ error: String)
}
