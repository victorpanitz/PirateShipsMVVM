//
//  ShipsListRepository.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 14/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

class ShipsListRepository: ShipsListRepositoryInput  {

    weak var output: ShipsListRepositoryOutput?
    
    private let api: APIProvider
    private let coreData: CoreDataProvider
    
    init (api: APIProvider = APICore(), coreData: CoreDataProvider = CoreDataManager()) {
        self.api = api
        self.coreData = coreData
    }
    
    func updateShipsList(_ ships: [Ship]) {
        coreData.deleteAllData(entity: "Ship_CD") { [weak self] (result) in
            switch result {
            case .succeeded(()):
                self?.saveDataLocally(entity: "Ship_CD", data: ships.map{ $0.toDict })
                
            case .failed(let error):
                self?.output?.updateShipsListFailed(error: error)
            }
        }
    }
    
    func retrieveShips() {
        coreData.retrieveAllData(entity: "Ship_CD") { [output] (result: Result<[Ship_CD]>) in
            switch result {
            case .succeeded(let ships):
                output?.retrieveLocalDataSucceeded(ships: ships.compactMap { Ship(ship_CD: $0) })
            case .failed(let error) :
                output?.retrieveLocalDataFailed(error: error)
            }
        }
    }
    
    func fetchPirateShips() {
        api.request(url: [.base,.pirateShips], httpMethod: HttpMethod.get) { [output] (status: Result<PirateShipsOutput>) in
            switch status {
            case .succeeded(let result):
                output?.fetchDataSucceeded(ships: result.ships.compactMap{ $0.map{ Ship(output: $0) } })
            case .failed(let error):
                output?.fetchDataFailed(error: error)
            }
        }
    }
    
    private func saveDataLocally(entity: String, data: [[String: Any?]]) {
        coreData.saveData(entity: "Ship_CD", data: data, completion: { [output] (result) in
            switch result {
            case .succeeded(()):
                output?.updateShipsListSucceeded()
                
            case .failed(let error) :
                output?.updateShipsListFailed(error: error)
            }
        })
    }
}
