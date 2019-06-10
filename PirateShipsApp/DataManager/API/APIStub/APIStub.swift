//
//  APIStub.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 14/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

class APIStub: APIProvider {
    
    public var urlPassed: String?
    public var httpMethodPassed: HttpMethod?
    public var requestDataCalled: Bool?
    
    private let status: Result<Decodable>
    
    init(status: Result<Decodable>) {
        self.status = status
    }

    public func clear() {
        urlPassed = nil
        httpMethodPassed = nil
        requestDataCalled = nil
    }
    
    func request<T>(url: [PathURL], httpMethod: HttpMethod, completion: @escaping (Result<T>) -> Void) where T : Decodable {
        httpMethodPassed = httpMethod
        
        urlPassed = url
            .map{ $0.rawValue}
            .reduce("", +)
        
        requestDataCalled = true

        switch status {
        case .succeeded(let result) : completion(.succeeded(result as! T))
        case .failed(let error):  completion(.failed(error))
        }
        
    }
    
}
