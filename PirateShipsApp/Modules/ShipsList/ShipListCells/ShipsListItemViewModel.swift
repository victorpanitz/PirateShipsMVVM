//
//  ShipsListItemPresenter.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 17/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipsListItemViewModel {
    
    private struct ShipItem {
        var title: String
        var image: String
        var price: Double
    }
    
    private let bag = DisposeBag()
    private let shipItem: ShipItem
    
    private let _responseFeedback = PublishSubject<Void>()
    private let _identityFeedback = PublishSubject<Void>()
    
    private let _image = BehaviorRelay<String>(value: "")
    private let _title = BehaviorRelay<String>(value: "")
    private let _price = BehaviorRelay<String>(value: "")
    
    let itemTouchCancelled = PublishSubject<Void>()
    let itemTouchEnded = PublishSubject<Void>()
    let itemTouchBegan = PublishSubject<Void>()
    
    var image: Observable<String> {
        return _image.asObservable()
    }
    
    var title: Observable<String> {
        return _title.asObservable()
    }
    
    var price: Observable<String> {
        return _price.asObservable()
    }
    
    var identityFeedback: Observable<Void> {
        return _identityFeedback.asObservable()
    }

    var responseFeedback: Observable<Void> {
        return _responseFeedback.asObservable()
    }
    
    init(title: String?, image: String?, price: Double?) {
        shipItem = ShipItem(
            title: title ?? "Unknown",
            image: image ?? "https://ichef.bbci.co.uk/images/ic/640x360/p06gsqm7.jpg",
            price: price ?? 0
        )
        
        setValues()
        setupSubscriptions()
    }
    
    func setValues() {
        _title.accept(shipItem.title)
        _image.accept(shipItem.image)
        
        shipItem.price > 0
            ? _price.accept(String(format: "$%.2f", shipItem.price))
            : _price.accept("$xxx.xx")
    }
    
    func setupSubscriptions() {
        itemTouchBegan
            .subscribe({ [weak self] (_) in
                self?._responseFeedback.onNext(())
            })
            .disposed(by: bag)

        itemTouchEnded
            .subscribe({ [weak self] (_) in
                self?._identityFeedback.onNext(())
            })
            .disposed(by: bag)

        itemTouchCancelled
            .subscribe({ [weak self] (_) in
                self?._identityFeedback.onNext(())
            })
            .disposed(by: bag)
    }
    
}
