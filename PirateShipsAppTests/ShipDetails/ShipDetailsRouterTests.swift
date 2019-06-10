//
//  ShipDetailsRouterTests.swift
//  PirateShipsAppTests
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest

@testable import PirateShipsApp

private class ShipDetailsRouterTests: XCTestCase {
    
    private var sut_router: ShipDetailsFactory!
    
    override func setUp() {
        let ship = Ship(id: 0, title: "", imageUrl: "", description: "", type: .yo, price: 0)
        
        sut_router = ShipDetailsFactory(ship: ship)
    }
    
    func test_when_make_ViewController_called() {
        XCTAssert(sut_router.makeViewController() is ShipDetailsViewController)
    }
    
}
