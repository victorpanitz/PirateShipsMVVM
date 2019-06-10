//
//  CoreDataProtocol.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 15/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

protocol CoreDataProvider: AnyObject {
    func saveData(entity: String, data: [[String: Any?]], completion: @escaping (Result<()>) -> Void)
    func deleteAllData(entity: String, completion: @escaping (Result<()>) -> Void)
    func retrieveAllData<T: Any>(entity: String, completion: @escaping (Result<T>) -> Void)
}
