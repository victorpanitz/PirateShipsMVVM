//
//  ShipsListRouterTests.swift
//  PirateShipsAppTests
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest

@testable import PirateShipsApp

private class ShipsListRouterTests: XCTestCase {
    
    private var sut_router: ShipsListRouter!
    
    override func setUp() {
        sut_router = ShipsListRouter()
    }
    
    func test_when_make_ViewController_called() {
        XCTAssert(sut_router.makeViewController() is ShipsListViewController)
    }
    
}
