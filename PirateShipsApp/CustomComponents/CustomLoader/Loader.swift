//
//  Loader.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

final class Loader: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.tintColor = .lightGray
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
}
