//
//  ShipsLisItemtCell.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 16/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ShipsListItemCell: UICollectionViewCell {
    
    private lazy var imageView : UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        imageV.backgroundColor = UIColor.clear
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.layer.cornerRadius = frame.width * 0.1
        imageV.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner])
        return imageV
    }()
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "Helvetica", size: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let priceLabel: CustomLabel = {
        let label = CustomLabel()
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.font = UIFont(name: "Helvetica-Bold", size: 12)
        label.textColor = .lightGray
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private var viewModel: ShipsListItemViewModel?
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupCell()
        setupImageView()
        setupTitleLabel()
        setupPriceLabel()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }
    
    func injectViewModel(_ viewModel: ShipsListItemViewModel) {
        self.viewModel = viewModel
        
        setupObservables()
    }
    
    private func setupCell() {
        layer.cornerRadius = frame.width * 0.1
        layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])        
        layer.bounds = layer.bounds
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 10
    }
    
    private func setupImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: frame.height * 0.85)
            ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width*0.35),
            ])
    }
    
    private func setupPriceLabel() {
        addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            priceLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
    }
    
    private func setupObservables() {
        viewModel?.title
            .asObservable()
            .observeOn(MainScheduler())
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.price
            .asObservable()
            .observeOn(MainScheduler())
            .bind(to: priceLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.image
            .asObservable()
            .observeOn(MainScheduler())
            .bind(onNext: { [weak self] (image) in
                self?.imageView.loadImage(image, placeHolder: UIImage(named: "img_sea"))
            })
            .disposed(by: bag)
        
        viewModel?.responseFeedback
            .asObservable()
            .observeOn(MainScheduler())
            .bind(onNext: { (_) in
                UIView.animate(withDuration: 0.05) { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    self?.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMinYCorner, .layerMinXMaxYCorner])
                    self?.imageView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMinYCorner])
                }
            })
            .disposed(by: bag)
        
        viewModel?.identityFeedback
            .asObservable()
            .observeOn(MainScheduler())
            .bind(onNext: { (_) in
                UIView.animate(withDuration: 0.05) { [weak self] in
                    self?.transform = .identity
                    self?.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
                    self?.imageView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner])
                }
            })
            .disposed(by: bag)
        
        
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    
        viewModel?.itemTouchCancelled.onNext(())
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        viewModel?.itemTouchEnded.onNext(())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        viewModel?.itemTouchBegan.onNext(())
    }
    
}
