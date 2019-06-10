//
//  ShipDetailsViewModelTests.swift
//  PirateShipsAppTests
//
//  Created by Victor on 22/05/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import PirateShipsApp

final class ShipDetailsViewModelTests: XCTestCase {

    private var scheduler: TestScheduler!
    private var bag: DisposeBag!
    private var sut_viewModel: ShipDetailsViewModel!
    
    private var titleObserver: TestableObserver<String>!
    private var descriptionObserver: TestableObserver<String>!
    private var imageObserver: TestableObserver<String>!
    private var priceObserver: TestableObserver<String>!
    private var alertObserver: TestableObserver<String>!
    
    func setup(greeting: PirateGreeting = .ay) {
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        
        let ship = Ship(
            id: 1,
            title: "title value",
            imageUrl: "image value",
            description: "description value",
            type: greeting,
            price: 10.5
        )
        
        sut_viewModel = ShipDetailsViewModel(ship: ship)
        
        titleObserver = scheduler.createObserver(String.self)
        descriptionObserver = scheduler.createObserver(String.self)
        imageObserver = scheduler.createObserver(String.self)
        priceObserver = scheduler.createObserver(String.self)
        alertObserver = scheduler.createObserver(String.self)
        
        makeBinds()
    }
    
    override func setUp() {
        setup()
    }
    
    private func makeBinds() {
        sut_viewModel.title
            .bind(to: titleObserver)
            .disposed(by: bag)
        
        sut_viewModel.description
            .bind(to: descriptionObserver)
            .disposed(by: bag)
        
        sut_viewModel.price
            .bind(to: priceObserver)
            .disposed(by: bag)
        
        sut_viewModel.image
            .bind(to: imageObserver)
            .disposed(by: bag)
        
        sut_viewModel.showAlert
            .bind(to: alertObserver)
            .disposed(by: bag)
    }

    func test_TitlePassed_GivenViewModelInitialized_ShouldPassTheReceivedTitle() {
        XCTAssertEqual(
            titleObserver.events,
            [.next(0, "title value")]
        )
    }
    
    func test_DescriptionPassed_GivenViewModelInitialized_ShouldPassTheReceivedDescription() {
        XCTAssertEqual(
            descriptionObserver.events,
            [.next(0, "description value")]
        )
    }
    
    func test_PricePassed_GivenViewModelInitialized_ShouldPassTheReceivedPrice() {
        XCTAssertEqual(
            priceObserver.events,
            [.next(0, "$10.50")]
        )
    }
    
    func test_ImagePassed_GivenViewModelInitialized_ShouldPassTheReceivedImage() {
        XCTAssertEqual(
            imageObserver.events,
            [.next(0, "image value")]
        )
    }
    
    func test_GreetingPassed_GivenShowGreetingTappedWithKeyAH_ShouldReturnAhMessage() {
        setup(greeting: .ah)
        runGreetingActions()
        
        XCTAssertEqual(
            alertObserver.events,
            [
                .next(10, "Ahoi!"),
                .next(20, "Ahoi!")
            ]
        )
    }
    
    func test_GreetingPassed_GivenShowGreetingTappedWithKeyAY_ShouldReturnAyMessage() {
        runGreetingActions()
        
        XCTAssertEqual(
            alertObserver.events,
            [
                .next(10, "Aye Aye!"),
                .next(20, "Aye Aye!")
            ]
        )
    }
    
    func test_GreetingPassed_GivenShowGreetingTappedWithKeyAR_ShouldReturnArMessage() {
        setup(greeting: .ar)
        runGreetingActions()
        
        XCTAssertEqual(
            alertObserver.events,
            [
                .next(10, "Arrr!"),
                .next(20, "Arrr!")
            ]
        )
    }
    
    func test_GreetingPassed_GivenShowGreetingTappedWithKeyAY_ShouldReturnYoMessage() {
        setup(greeting: .yo)
        runGreetingActions()
        
        XCTAssertEqual(
            alertObserver.events,
            [
                .next(10, "Yo ho hooo!"),
                .next(20, "Yo ho hooo!")
            ]
        )
    }
    
    private func runGreetingActions() {
        scheduler
            .createColdObservable([
                .next(10, ()),
                .next(20, ()),
                ])
            .bind(to: sut_viewModel.greetingTapped)
            .disposed(by: bag)
        
        scheduler.start()
    }
}

