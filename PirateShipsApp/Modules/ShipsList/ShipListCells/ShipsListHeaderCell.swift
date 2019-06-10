//
//  ShipsListHeaderCell.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 17/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

final class ShipsListHeaderCell: UICollectionViewCell {

    private let headerLabel: CustomLabel = {
        let label = CustomLabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 47)
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PIRATE\nSHIPS"
        label.sizeToFit()
        label.layer.shadowRadius = 4.0
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeaderLabel()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil}
    
    private func setupHeaderLabel() {
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
}
