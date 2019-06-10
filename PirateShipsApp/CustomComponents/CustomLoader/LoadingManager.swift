//
//  LoaderManagr.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

internal struct LoadingManager {
    
    static private var loader: UIActivityIndicatorView?
    
    internal static func show(in viewController: UIViewController) {
        guard self.loader == nil else { return }
        let loader = Loader(frame: .zero)
        self.loader = loader
        
        DispatchQueue.main.async {
            viewController.view.addSubview(loader)
            loader.startAnimating()
        }
    }
    
    internal static func hide() {
        guard let loader = loader else { return }
        
        DispatchQueue.main.async {
            loader.stopAnimating()
            self.loader?.removeFromSuperview()
        }
        
        self.loader = nil
    }
}
