//
//  ShipsListPresenter.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 13/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import RxSwift
import RxCocoa

final class ShipsListViewModel {

    private let repository: ShipsListRepositoryInput
    private let router: ShipsListRoutering
    private let bag = DisposeBag()
    
    private let _navigationTitle = BehaviorRelay<String>(value: "")
    private let _messageError = PublishSubject<String>()
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _ships = BehaviorRelay<[Ship]>(value: [])

    let cellTriggered = PublishSubject<Int>()
    let refreshTriggered = PublishSubject<Void>()
    
    var navigationTitle: Observable<String> {
        return _navigationTitle.asObservable()
    }
    
    var messageError: Observable<String> {
        return _messageError.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }
    
    var ships: Observable<[Ship]> {
        return _ships.asObservable()
    }
    
    init(router: ShipsListRoutering, repository: ShipsListRepositoryInput) {
        self.router = router
        self.repository = repository
        
        repository.output = self
        
        setValues()
        setSubscriptions()
        handleData()
    }
    
    private func handleData() {
        repository.retrieveShips()
        repository.fetchPirateShips()
    }
    
    private func setValues() {
        _isLoading.accept(true)
        _navigationTitle.accept("Pirate Ships")
    }
    
    private func setSubscriptions() {
        cellTriggered
            .filter { [weak self] index in
                self.map { (0..<$0._ships.value.count).contains(index) } ?? false
            }
            .subscribe(onNext: { [weak self] (index) in
                self.map {
                    $0.router.navigateToShipDetails(ship: $0._ships.value[index])
                }
            })
            .disposed(by: bag)
        
        refreshTriggered
            .subscribe(onNext: { [weak self] (_) in
                self?._isLoading.accept(true)
                self?.repository.fetchPirateShips()
            })
            .disposed(by: bag)
    }
}

extension ShipsListViewModel: ShipsListRepositoryOutput {
    func updateShipsListSucceeded() {
        repository.retrieveShips()
    }
    
    func updateShipsListFailed(error: String) {
        _messageError.onNext(error)
    }
    
    func fetchDataSucceeded(ships: [Ship]) {
        _isLoading.accept(false)
        _ships.accept(ships)
        repository.updateShipsList(ships)
    }
    
    func fetchDataFailed(error: String) {
        _isLoading.accept(false)
        _messageError.onNext(error)
    }
    
    func retrieveLocalDataSucceeded(ships: [Ship]) {
        let shipsSorted = ships.sorted(by: {$0.title ?? "" > $1.title ?? ""})
        _ships.accept(shipsSorted)

        /*
         great point to discuss with ux team
         to show a friendly empty screen
         when ships.count == 0  :)
         */
    }
    
    func retrieveLocalDataFailed(error: String) {
        _messageError.onNext(error)
    }
    
}
