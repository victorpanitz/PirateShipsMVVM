//
//  ShipsListRouter.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 17/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

class ShipsListRouter: ShipsListRoutering {
    
    private weak var view: UIViewController?

    init() {}
    
    func makeViewController() -> UIViewController {
        let repository = ShipsListRepository()
        let viewModel = ShipsListViewModel(router: self, repository: repository)
        let viewController = ShipsListViewController(viewModel: viewModel)
        self.view = viewController
        
        return viewController
    }
    
    func navigateToShipDetails(ship: Ship) {
        let router = ShipDetailsFactory(ship: ship)
        view?.navigationController?.pushViewController(router.makeViewController(), animated: true)
    }
}
