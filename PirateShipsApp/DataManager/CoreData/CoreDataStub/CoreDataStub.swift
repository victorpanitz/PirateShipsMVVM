//
//  CoreDataStub.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 16/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

class CoreDataStub: CoreDataProvider {
    
    public var entity: String?
    public var elementsPassed: Any?
    public var saveDataCalled: Bool?
    public var deleteDataCalled: Bool?
    public var retrieveDataCalled: Bool?
    
    private let saveStatus: Result<()>
    private let deleteStatus: Result<()>
    private let retrieveStatus: Result<Any>
    
    init(saveStatus: Result<()>, deleteStatus: Result<()>, retrieveStatus: Result<Any>) {
        self.saveStatus = saveStatus
        self.deleteStatus = deleteStatus
        self.retrieveStatus = retrieveStatus
    }
    
    public func clear() {
        entity = nil
        elementsPassed = nil
        saveDataCalled = nil
        deleteDataCalled = nil
        retrieveDataCalled = nil
    }
    
    func saveData<T>(entity: String, data: T, completion: @escaping (Result<()>) -> Void) {
        self.saveDataCalled = true
        self.entity = entity
        
        switch saveStatus {
        case .succeeded(_) : completion(.succeeded(()))
        case .failed(let error): completion(.failed(error))
        }
    }
    
    func deleteAllData(entity: String, completion: @escaping (Result<()>) -> Void) {
        self.deleteDataCalled = true
        self.entity = entity
        
        switch deleteStatus {
        case .succeeded(_) : completion(.succeeded(()))
        case .failed(let error): completion(.failed(error))
        }
    }
    
    func retrieveAllData<T>(entity: String, completion: @escaping (Result<T>) -> Void) {
        self.retrieveDataCalled = true
        self.entity = entity
        
        switch retrieveStatus {
        case .succeeded(let result) : completion(.succeeded(result as! T))
        case .failed(let error): completion(.failed(error))
        }
    }
}
