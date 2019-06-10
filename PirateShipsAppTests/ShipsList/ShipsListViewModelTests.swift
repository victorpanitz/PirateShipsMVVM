//
//  PirateShipsAppTests.swift
//  PirateShipsAppTests
//
//  Created by Victor on 12/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import PirateShipsApp

private class ShipsListViewModelTests: XCTestCase {

    private var scheduler: TestScheduler!
    private var bag: DisposeBag!
    
    private var sut_viewModel: ShipsListViewModel!
    private var repository: ShipsListRepositoryInputSpy!
    private var router: ShipsListRouterSpy!
    
    private var navigationTitleObserver: TestableObserver<String>!
    private var messageErrorObserver: TestableObserver<String>!
    private var isLoadingObserver: TestableObserver<Bool>!
    private var shipsObserver: TestableObserver<[Ship]>!
    
    override func setUp() {
        router = ShipsListRouterSpy()
        repository = ShipsListRepositoryInputSpy()
        sut_viewModel = ShipsListViewModel(router: router, repository: repository)
        
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        
        navigationTitleObserver = scheduler.createObserver(String.self)
        messageErrorObserver = scheduler.createObserver(String.self)
        isLoadingObserver = scheduler.createObserver(Bool.self)
        shipsObserver = scheduler.createObserver([Ship].self)
        
        makeBinds()
    }
    
    private func makeBinds() {
        sut_viewModel.navigationTitle
            .bind(to: navigationTitleObserver)
            .disposed(by: bag)
        
        sut_viewModel.messageError
            .bind(to: messageErrorObserver)
            .disposed(by: bag)
        
        sut_viewModel.isLoading
            .bind(to: isLoadingObserver)
            .disposed(by: bag)
        
        sut_viewModel.ships
            .bind(to: shipsObserver)
            .disposed(by: bag)
    }
    
    func test_GivenViewModelInitialized_ShouldShowLoadingFeedback() {
        XCTAssertEqual(isLoadingObserver.events, [.next(0, true)])
    }
    
    func test_GivenViewModelInitialized_ShouldSetNavigationTitle() {
        XCTAssertEqual(navigationTitleObserver.events, [.next(0, "Pirate Ships")])
    }
    
    func test_GivenViewModelInitialized_ShouldTryToRetrieveLocalSavedShips() {
        XCTAssertEqual(repository.retrieveShipsCalled, true)
    }
    
    func test_GivenViewModelInitialized_ShouldTryToFetchRemoteShips() {
        XCTAssertEqual(repository.fetchPirateShipsCalled, true)
    }
    
    func test_when_cell_triggered() {
        sut_viewModel.retrieveLocalDataSucceeded(ships: [.dummy_navigation])
        sut_viewModel.cellTriggered.onNext(0)
        
        XCTAssertEqual(router.navigateToShipDetailsCalled, true)
        XCTAssertEqual(router.shipTitlePassed, "ship title value")
        XCTAssertEqual(router.shipDescriptionPassed, "ship description value")
        XCTAssertEqual(router.shipImagePassed, "ship image value")
        XCTAssertEqual(router.shipGreetingTypePassed, .yo)
        XCTAssertEqual(router.shipPricePassed, 14.2)
    }
    
    func test_when_fetch_data_succeeded() {
        sut_viewModel.fetchDataSucceeded(ships: Ship.dummy_ships_data)
        
        XCTAssertEqual(isLoadingObserver.events[1], .next(0, false))
        
        XCTAssertEqual(repository.updateShipsListCalled, true)
        XCTAssertEqual(repository.elementsPassed?.count, 3)
        
        XCTAssertEqual(repository.elementsPassed?[0].title, "ship1 title value")
        XCTAssertEqual(repository.elementsPassed?[0].description, "ship1 description value")
        XCTAssertEqual(repository.elementsPassed?[0].imageUrl, "ship1 imageUrl value")
        XCTAssertEqual(repository.elementsPassed?[0].type, .yo)
        XCTAssertEqual(repository.elementsPassed?[0].price, 10.3)
        
        XCTAssertEqual(repository.elementsPassed?[1].title, "ship2 title value")
        XCTAssertEqual(repository.elementsPassed?[1].description, "ship2 description value")
        XCTAssertEqual(repository.elementsPassed?[1].imageUrl, "ship2 imageUrl value")
        XCTAssertEqual(repository.elementsPassed?[1].type, .yo)
        XCTAssertEqual(repository.elementsPassed?[1].price, 8.5)
        
        XCTAssertEqual(repository.elementsPassed?[2].title, "ship3 title value")
        XCTAssertEqual(repository.elementsPassed?[2].description, "ship3 description value")
        XCTAssertEqual(repository.elementsPassed?[2].imageUrl, "ship3 imageUrl value")
        XCTAssertEqual(repository.elementsPassed?[2].type, .yo)
        XCTAssertEqual(repository.elementsPassed?[2].price, 4.4)
    }
    
    func test_GivenFetchDataSucceeded_WithEmptyList_ShouldUpdateLocalShipsListWithEmptyList() {
        sut_viewModel.fetchDataSucceeded(ships: [])
        
        XCTAssertEqual(isLoadingObserver.events.contains(.next(0, false)), true)
        XCTAssertEqual(repository.updateShipsListCalled, true)
        XCTAssertEqual(repository.elementsPassed?.count, 0)
    }
    
    func test_GivenFetchDataFailed_ShouldShowTheReturnedError() {
        sut_viewModel.fetchDataFailed(error: "error value")
        
        XCTAssertEqual(isLoadingObserver.events[1], .next(0, false))
        XCTAssertEqual(messageErrorObserver.events, [.next(0, "error value")])
    }
    
    func test_GivenRetriveLocalDataSucceeded_ShouldUpdateShipsList() {
        sut_viewModel.retrieveLocalDataSucceeded(ships: Ship.dummy_ships_data)
        
        let matcher = [
            Ship (
                id: 0103,
                title: "ship3 title value",
                imageUrl: "ship3 imageUrl value",
                description: "ship3 description value",
                type: .yo,
                price: 4.4
            ),
            
            Ship (
                id: 0102,
                title: "ship2 title value",
                imageUrl: "ship2 imageUrl value",
                description: "ship2 description value",
                type: .yo,
                price: 8.5
            ),
            
            Ship (
                id: 0101,
                title: "ship1 title value",
                imageUrl: "ship1 imageUrl value",
                description: "ship1 description value",
                type: .yo,
                price: 10.3
            )
        ]
        
        XCTAssertEqual(shipsObserver.events, [.next(0, []), .next(0, matcher)])
    }
    
    func test_GivenRetriveLocalDataFailed_ShouldShowTheReturnedError() {
        sut_viewModel.retrieveLocalDataFailed(error: "error value")

        XCTAssertEqual(messageErrorObserver.events, [.next(0, "error value")])
    }
    
    func test_GivenUpdateShipsListSucceeded_ShouldFetchRemoteShips(){
        sut_viewModel.updateShipsListSucceeded()
        
        XCTAssert(repository.retrieveShipsCalled == true)
    }
    
    func test_GivenUpdateShipsListFailed_ShouldFetchRemoteShips(){
        sut_viewModel.updateShipsListFailed(error: "error value")
        
        XCTAssertEqual(messageErrorObserver.events, [.next(0, "error value")])
    }
    
    func test_GivenRefreshControlTriggered_ShouldFetchRemoteShips() {
        sut_viewModel.refreshTriggered.onNext(())
        
        XCTAssertEqual(isLoadingObserver.events[1], .next(0, true))
        XCTAssert(repository.fetchPirateShipsCalled == true)
    }

}

fileprivate class ShipsListRouterSpy: ShipsListRoutering {
    var navigateToShipDetailsCalled: Bool?
    var shipTitlePassed: String?
    var shipDescriptionPassed: String?
    var shipImagePassed: String?
    var shipGreetingTypePassed: PirateGreeting?
    var shipPricePassed: Double?
    
    func navigateToShipDetails(ship: Ship) {
        navigateToShipDetailsCalled = true
        shipTitlePassed = ship.title
        shipDescriptionPassed = ship.description
        shipImagePassed = ship.imageUrl
        shipGreetingTypePassed = ship.type
        shipPricePassed = ship.price
    }
}

fileprivate class ShipsListRepositoryInputSpy: ShipsListRepositoryInput {
    
    var output: ShipsListRepositoryOutput?
    var updateShipsListCalled: Bool?
    var elementsPassed: [Ship]?
    var fetchPirateShipsCalled: Bool?
    var retrieveShipsCalled: Bool?
    
    func fetchPirateShips() {
        fetchPirateShipsCalled = true
    }
    
    func updateShipsList(_ ships: [Ship]) {
        updateShipsListCalled = true
        elementsPassed = ships
    }
    
    func retrieveShips() {
        retrieveShipsCalled = true
    }

}

extension Ship {
    static var dummy_navigation: Ship {
        return Ship (
            id: 0101,
            title: "ship title value",
            imageUrl: "ship image value",
            description: "ship description value",
            type: .yo,
            price: 14.2
        )
    }
    
    static var dummy_ships_data: [Ship] {
        return [
            Ship (
                id: 0101,
                title: "ship1 title value",
                imageUrl: "ship1 imageUrl value",
                description: "ship1 description value",
                type: .yo,
                price: 10.3
            ),
            Ship (
                id: 0102,
                title: "ship2 title value",
                imageUrl: "ship2 imageUrl value",
                description: "ship2 description value",
                type: .yo,
                price: 8.5
            ),
            Ship (
                id: 0103, 
                title: "ship3 title value",
                imageUrl: "ship3 imageUrl value",
                description: "ship3 description value",
                type: .yo,
                price: 4.4
            )
        ]
    }
}
