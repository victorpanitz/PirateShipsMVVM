//
//  ShipsListProtocols.swift
//  PirateShipsApp
//
//  Created by Victor on 13/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

protocol ShipsListRepositoryInput: AnyObject {
    var output: ShipsListRepositoryOutput? {get set}
    
    func updateShipsList(_ ships: [Ship])
    func retrieveShips()
    func fetchPirateShips()
}

protocol ShipsListRepositoryOutput: AnyObject {
    func fetchDataSucceeded(ships: [Ship])
    func fetchDataFailed(error: String)
    func updateShipsListSucceeded()
    func updateShipsListFailed(error: String)
    func retrieveLocalDataSucceeded(ships: [Ship]) 
    func retrieveLocalDataFailed(error: String)
}

protocol ShipsListRoutering: AnyObject {
    func navigateToShipDetails(ship: Ship)
}
