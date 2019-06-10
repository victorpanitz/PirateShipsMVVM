//
//  ShipDetailsViewController.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ShipDetailsViewController: UIViewController {

    private let imageView : UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIImageView())
        
    private let titleLabel: CustomLabel = {
        $0.backgroundColor = .clear
        $0.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(CustomLabel())
    
    private let descriptionTextView: UITextView = {
        $0.backgroundColor = .clear
        $0.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        $0.textAlignment = .justified
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UITextView())
    
    private let priceLabel: CustomLabel = {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        $0.numberOfLines = 1
        $0.font = UIFont(name: "Helvetica-Bold", size: 12)
        $0.textColor = .white
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        
        return $0
    }(CustomLabel())
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(named: "ic_close_selected"), for: .highlighted)
        button.setImage(UIImage(named: "ic_close_normal"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let greetingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(named: "ic_pirate_selected"), for: .highlighted)
        button.setImage(UIImage(named: "ic_pirate_normal"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: UIImage(named: "ic_pirate_normal"),
            style: .plain,
            target: self,
            action: nil
        )
    }()

    private let bag = DisposeBag()
    private let viewModel: ShipDetailsViewModel
    
    init(viewModel: ShipDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
     
        setupNavigtion()
        setupImageView()
        setupTitleLabel()
        setupDescriptionTextView()
        setupPriceLabel()
        setupObservables()
    }
    
    private func setupNavigtion() {
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height*0.3)
            ]
        )
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: view.frame.height*0.1)
            ]
        )
    }
    
    private func setupDescriptionTextView() {
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    private func setupPriceLabel() {
        view.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: view.frame.height*0.05)
            ]
        )
    }

    private func setupObservables() {
        viewModel.image
            .asObservable()
            .bind(onNext: { [weak self] (image) in
                self?.imageView.loadImage(image, placeHolder: UIImage(named: "img_sea"))
            })
            .disposed(by: bag)
        
        viewModel.title
            .asObservable()
            .observeOn(MainScheduler())
            .bind(to: titleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.description
            .asObservable()
            .observeOn(MainScheduler())
            .bind(to: descriptionTextView.rx.text)
            .disposed(by: bag)
        
        viewModel.price
            .asObservable()
            .observeOn(MainScheduler())
            .bind(to: priceLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.greetingTapped)
            .disposed(by: bag)
        
        viewModel.showAlert
            .asObservable()
            .observeOn(MainScheduler())
            .subscribe(onNext: { [weak self] value in
                let alert = UIAlertController(
                    title: "We are pirates!",
                    message: value,
                    preferredStyle: .alert
                )
                
                let action = UIAlertAction(
                    title: "Ok",
                    style: .default,
                    handler: nil
                )
                
                alert.addAction(action)
                
                self?.present(
                    alert,
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: bag)
    }
}
