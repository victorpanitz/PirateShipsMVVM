//
//  ShipDetailsPresenter.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 18/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipDetailsViewModel {
    
    private let ship: Ship
    private let bag = DisposeBag()
    private let _showAlert = PublishSubject<String>()
    
    private let _title = BehaviorRelay<String>(value: "")
    private let _description = BehaviorRelay<String>(value: "")
    private let _image = BehaviorRelay<String>(value: "")
    private let _price = BehaviorRelay<String>(value: "")
    private let _navigationTitle = BehaviorRelay<String>(value: "")
    
    let greetingTapped = PublishSubject<Void>()
    let closeButtonTapped = PublishSubject<Void>()
    
    var navigationTitle: Observable<String> {
        return _navigationTitle.asObservable()
    }
    
    var title: Observable<String> {
        return _title.asObservable()
    }
    
    var description: Observable<String> {
        return _description.asObservable()
    }
    
    var image: Observable<String> {
        return _image.asObservable()
    }
    
    var price: Observable<String> {
        return _price.asObservable()
    }
    
    var showAlert: Observable<String> {
        return _showAlert.asObservable()
    }
    
    init(ship: Ship) {
        self.ship = ship
        
        setValues()
        setSubscriptions()
    }
    
    private func setValues() {
        _navigationTitle.accept("Detail")
        
        _title.accept(ship.title ?? "Unknown")
        
        _description.accept(ship.description ?? "Unknown")
        
        _image.accept(ship.imageUrl ?? "https://ichef.bbci.co.uk/images/ic/640x360/p06gsqm7.jpg")
        
        _price.accept(
            {
                guard
                    let price = ship.price,
                    price > 0
                    else { return "$xxx.xx" }
                
                return  String(format: "$%.2f", price)
            }()
        )
    }
    
    func setSubscriptions() {
        greetingTapped
            .subscribe({ [weak self] (_) in
                self.map { $0._showAlert.onNext( $0.ship.type?.rawValue ?? "" ) }
            })
            .disposed(by: bag)
    }
}
