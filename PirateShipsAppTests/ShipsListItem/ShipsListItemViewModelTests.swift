//
//  ShipsListItemPresenter.swift
//  PirateShipsAppTests
//
//  Created by Victor Magalhaes on 17/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import PirateShipsApp

private final class ShipsListItemViewModelTests: XCTestCase {

    private var sut_viewModel: ShipsListItemViewModel!
    
    private var titleObserver: TestableObserver<String>!
    private var imageObserver: TestableObserver<String>!
    private var priceObserver: TestableObserver<String>!
    private var identityFeedbackObserver: TestableObserver<Void>!
    private var responseFeedbackObserver: TestableObserver<Void>!
    private var scheduler: TestScheduler!

    private var bag: DisposeBag!
    
    private func setup(title: String?, image: String?, price: Double?) {
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        
        sut_viewModel = ShipsListItemViewModel(title: title, image: image, price: price)

        titleObserver = scheduler.createObserver(String.self)
        imageObserver = scheduler.createObserver(String.self)
        priceObserver = scheduler.createObserver(String.self)
        identityFeedbackObserver = scheduler.createObserver(Void.self)
        responseFeedbackObserver = scheduler.createObserver(Void.self)

        makeBinds()
    }
    
    override func setUp() {
        setup(title: "title value", image: "image value", price: 10)
    }
    
    private func makeBinds() {
        sut_viewModel.title
            .bind(to: titleObserver)
            .disposed(by: bag)
        
        sut_viewModel.price
            .bind(to: priceObserver)
            .disposed(by: bag)
        
        sut_viewModel.image
            .bind(to: imageObserver)
            .disposed(by: bag)
        
        sut_viewModel.responseFeedback
            .bind(to: responseFeedbackObserver)
            .disposed(by: bag)
        
        sut_viewModel.identityFeedback
            .bind(to: identityFeedbackObserver)
            .disposed(by: bag)
        
    }

    func test_TitlePassed_GivenViewModelInitialized_ShouldPassTheReceivedTitle() {
        XCTAssertEqual(
            titleObserver.events,
            [.next(0, "title value")]
        )
    }
    
    func test_PricePassed_GivenViewModelInitialized_ShouldPassTheReceivedPrice() {
        XCTAssertEqual(
            priceObserver.events,
            [.next(0, "$10.00")]
        )
    }
    
    func test_ImagePassed_GivenViewModelInitialized_ShouldPassTheReceivedImage() {
        XCTAssertEqual(
            imageObserver.events,
            [.next(0, "image value")]
        )
    }
    
    func test_ItemTouchBegan_GivenItemTouchBegan_ShouldCallResponseFeedbackAnimation() {
        sut_viewModel.itemTouchBegan.onNext(())
        
        XCTAssertEqual(responseFeedbackObserver.events.count, 1)
    }
    
    func test_ItemEnded_GivenItemTouchEnded_ShouldCallIdentityFeedbackAnimation() {
        sut_viewModel.itemTouchEnded.onNext(())
        
        XCTAssertEqual(identityFeedbackObserver.events.count, 1)
    }
    
    func test_ItemTouchCanceled_GivenItemTouchCanceled_ShouldCallIdentityFeedbackAnimation() {
        sut_viewModel.itemTouchCancelled.onNext(())
        
        XCTAssertEqual(identityFeedbackObserver.events.count, 1)
    }
}
