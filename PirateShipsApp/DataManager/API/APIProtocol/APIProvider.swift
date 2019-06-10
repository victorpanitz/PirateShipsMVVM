//
//  APIProtocol.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 13/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

protocol APIProvider: AnyObject {
    func request<T: Decodable>(url: [PathURL], httpMethod: HttpMethod, completion: @escaping (Result<T>) -> Void)
}
