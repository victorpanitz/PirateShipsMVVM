//
//  ShipDetailsRouter.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

final class ShipDetailsFactory {
    
    private let ship: Ship
    
    init(ship: Ship) {
        self.ship = ship
    }
    
    func makeViewController() -> UIViewController {
        let viewModel = ShipDetailsViewModel(ship: ship)
        let viewController = ShipDetailsViewController(viewModel: viewModel)
        
        return viewController
    }
}
