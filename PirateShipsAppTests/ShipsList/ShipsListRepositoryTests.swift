//
//  ShipsListRepositoryTests.swift
//  PirateShipsAppTests
//
//  Created by Victor Magalhaes on 13/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest

@testable import PirateShipsApp

private class ShipsListRepositoryTests: XCTestCase {

    private var sut_repository: ShipsListRepository!
    private var output: ShipsListRepositoryOutputSpy!
    private var api: APIStub!
    private var coreData: CoreDataStub!
    
    func setup(
        apiStatus: Result<Decodable> = .succeeded(PirateShipsOutput.dummy_succeeded),
        saveStatus: Result<()> = .succeeded(()),
        deleteStatus: Result<()> = .succeeded(()),
        retrieveStatus: Result<Any> = .succeeded([Ship_CD.dummy_CD1, Ship_CD.dummy_CD2, Ship_CD.dummy_CD3])
        ) {
        output = ShipsListRepositoryOutputSpy()
        api = APIStub(status: apiStatus)
        coreData = CoreDataStub(saveStatus: saveStatus, deleteStatus: deleteStatus, retrieveStatus: retrieveStatus)
        sut_repository = ShipsListRepository(api: api, coreData: coreData)
        sut_repository.output = output
    }

    override func tearDown() {
        setup()
        api.clear()
    }

    func test_when_fetch_pirate_ships_called() {
        setup()
        sut_repository.fetchPirateShips()
        
        XCTAssert(api.urlPassed == "https://assets.shpock.com/mobile/interview-test/pirateships")
        XCTAssert(api.httpMethodPassed == .get)
        XCTAssert(api.requestDataCalled == true)
    }
    
    func test_when_fetch_pirate_ships_succeeded() {
        setup()
        sut_repository.fetchPirateShips()
        
        XCTAssert(output.fetchDataSucceededCalled == true)
        XCTAssert(output.elementsPassed?.count == 1)
        
        XCTAssert(output.elementsPassed?[0].title == "title value")
        XCTAssert(output.elementsPassed?[0].imageUrl == "image url value")
        XCTAssert(output.elementsPassed?[0].description == "description value")
        XCTAssert(output.elementsPassed?[0].type == .yo)
        XCTAssert(output.elementsPassed?[0].price == 86.34)
    }
    
    func test_when_fetchPirateShips_Failed() {
        setup(apiStatus: .failed("error value"))
        sut_repository.fetchPirateShips()
        
        XCTAssert(output.fetchDataFailedCalled == true)
        XCTAssert(output.errorMessagePassed == "error value")
    }

    func test_when_update_ships_list_called() {
        setup()

        let sample = Ship(id: 0101, title: "foo", imageUrl: "boo", description: "bar", type: .yo, price: 101.1)
        sut_repository.updateShipsList([sample])

        XCTAssert(coreData.entity == "Ship_CD")
    }

    func test_when_update_ships_list_succeeded() {
        setup()
        let sample = Ship(id: 0101, title: "foo", imageUrl: "boo", description: "bar", type: .yo, price: 101.1)
        sut_repository.updateShipsList([sample])

        XCTAssert(coreData.deleteDataCalled == true)
        XCTAssert(coreData.saveDataCalled == true)
        XCTAssert(output.updateShipsListSucceededCalled == true)
    }

    func test_when_update_ships_list_failed_during_removing_itens() {
        setup(deleteStatus: .failed("error deleting"))
        let sample = Ship(id: 0101, title: "foo", imageUrl: "boo", description: "bar", type: .yo, price: 101.1)
        sut_repository.updateShipsList([sample])

        XCTAssert(coreData.deleteDataCalled == true)
        XCTAssert(coreData.saveDataCalled == nil)
        XCTAssert(output.updateShipsListFailedCalled == true)
        XCTAssert(output.updateShipsListSucceededCalled == nil)
        XCTAssert(output.errorMessagePassed == "error deleting")
    }

    func test_when_update_ships_list_failed_during_saving_itens() {
        setup(saveStatus: .failed("error saving"))
        let sample = Ship(id: 0101, title: "foo", imageUrl: "boo", description: "bar", type: .yo, price: 101.1)
        sut_repository.updateShipsList([sample])

        XCTAssert(coreData.deleteDataCalled == true)
        XCTAssert(coreData.saveDataCalled == true)
        XCTAssert(output.updateShipsListFailedCalled == true)
        XCTAssert(output.updateShipsListSucceededCalled == nil)
        XCTAssert(output.errorMessagePassed == "error saving")
    }

    func test_when_retrieve_ships_called() {
        setup()
        sut_repository.retrieveShips()

        XCTAssert(coreData.entity == "Ship_CD")
    }

    func test_when_retrieve_ships_succeeded() {
        setup()
        sut_repository.retrieveShips()

        XCTAssert(coreData.retrieveDataCalled == true)

        XCTAssert(output.retrieveLocalDataSucceededCalled == true)
        XCTAssert(output.elementsPassed?.count == 3)

        XCTAssert(output.elementsPassed?[0].title == "ship1 title value")
        XCTAssert(output.elementsPassed?[0].description == "ship1 description value")
        XCTAssert(output.elementsPassed?[0].imageUrl == "ship1 imageUrl value")
        XCTAssert(output.elementsPassed?[0].type == .yo)
        XCTAssert(output.elementsPassed?[0].price == 10.3)

        XCTAssert(output.elementsPassed?[1].title == "ship2 title value")
        XCTAssert(output.elementsPassed?[1].description == "ship2 description value")
        XCTAssert(output.elementsPassed?[1].imageUrl == "ship2 imageUrl value")
        XCTAssert(output.elementsPassed?[1].type == .yo)
        XCTAssert(output.elementsPassed?[1].price == 8.5)

        XCTAssert(output.elementsPassed?[2].title == "ship3 title value")
        XCTAssert(output.elementsPassed?[2].description == "ship3 description value")
        XCTAssert(output.elementsPassed?[2].imageUrl == "ship3 imageUrl value")
        XCTAssert(output.elementsPassed?[2].type == .yo)
        XCTAssert(output.elementsPassed?[2].price == 4.4)
    }

    func test_when_retrieve_ships_failed() {
        setup(retrieveStatus: .failed("error retrieving"))
        sut_repository.retrieveShips()

        XCTAssert(coreData.retrieveDataCalled == true)
        XCTAssert(output.retrieveLocalDataFailedCalled == true)
        XCTAssert(output.errorMessagePassed == "error retrieving")
    }

}

fileprivate class ShipsListRepositoryOutputSpy: ShipsListRepositoryOutput{
    
    var fetchDataSucceededCalled: Bool?
    var fetchDataFailedCalled: Bool?
    var elementsPassed: [Ship]?
    var errorMessagePassed: String?
    var retrieveLocalDataSucceededCalled: Bool?
    var retrieveLocalDataFailedCalled: Bool?
    var updateShipsListSucceededCalled: Bool?
    var updateShipsListFailedCalled: Bool?
    
    func fetchDataSucceeded(ships: [Ship]) {
        fetchDataSucceededCalled = true
        elementsPassed = ships
    }
    
    func fetchDataFailed(error: String) {
        fetchDataFailedCalled = true
        errorMessagePassed = error
    }
    
    func retrieveLocalDataSucceeded(ships: [Ship]) {
        retrieveLocalDataSucceededCalled = true
        elementsPassed = ships
    }
    
    func retrieveLocalDataFailed(error: String) {
        retrieveLocalDataFailedCalled = true
        errorMessagePassed = error
    }
    
    func updateShipsListSucceeded() {
        updateShipsListSucceededCalled = true
        
    }
    
    func updateShipsListFailed(error: String) {
        updateShipsListFailedCalled = true
        errorMessagePassed = error
    }
    
}

extension PirateShipsOutput {
    static var dummy_succeeded: PirateShipsOutput {
        return PirateShipsOutput(
            success: true,
            ships: [ShipOutput(
                id: 0101,
                title: "title value",
                image: "image url value",
                detail: "description value",
                type: "yo",
                price: 86.34
                )
            ]
        )
    }
    
}

extension Ship_CD {
    
    static var dummy_CD1: Ship_CD {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.persistentContainer.viewContext
        
        let dummy = Ship_CD(context: managedContext)
        
        dummy.id = 0101
        dummy.title = "ship1 title value"
        dummy.image = "ship1 imageUrl value"
        dummy.detail = "ship1 description value"
        dummy.type = "yo"
        dummy.price = 10.3
        
        return dummy
    }
    
    static var dummy_CD2: Ship_CD {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.persistentContainer.viewContext
        
        let dummy = Ship_CD(context: managedContext)
        
        dummy.id = 0102
        dummy.title = "ship2 title value"
        dummy.image = "ship2 imageUrl value"
        dummy.detail = "ship2 description value"
        dummy.type = "yo"
        dummy.price = 8.5
        
        return dummy
    }
    
    static var dummy_CD3: Ship_CD {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.persistentContainer.viewContext
        
        let dummy = Ship_CD(context: managedContext)
        
        dummy.id = 0103
        dummy.title = "ship3 title value"
        dummy.image = "ship3 imageUrl value"
        dummy.detail = "ship3 description value"
        dummy.type = "yo"
        dummy.price = 4.4
        
        return dummy
    }

}
