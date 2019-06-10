//
//  ViewController.swift
//  PirateShipsApp
//
//  Created by Victor on 12/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ShipsListViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.register(ShipsListItemCell.self, forCellWithReuseIdentifier: "shipCell")
        collection.backgroundColor = UIColor.clear
        collection.contentMode = .scaleAspectFill
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.clipsToBounds = true
        collection.isUserInteractionEnabled = true
        collection.contentInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        
        return collection
    }()
    
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var ships = [Ship]()
    private let viewModel: ShipsListViewModel
    
    init(viewModel: ShipsListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    
        setupCollectionView()
        setupRefreshControl()
        setupObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Mark: Private methods
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .cyan
        collectionView.refreshControl = refreshControl
    }
    
    private func setupObservables() {
        viewModel.ships
            .bind(to: collectionView.rx
                .items(cellIdentifier: "shipCell", cellType: ShipsListItemCell.self)) { row, item, cell in
                    let viewModel = ShipsListItemViewModel(
                        title: item.title,
                        image: item.imageUrl,
                        price: item.price
                    )
    
                    cell.injectViewModel(viewModel)
            }
            .disposed(by: bag)
        
        viewModel.isLoading
            .asObservable()                                                     // I think it's not the best solution
            .observeOn(MainScheduler())                                         // for that, maybe an explicit model
            .subscribe(onNext: { (status) in                                    // representing each showing and hide status
                status ? LoadingManager.show(in: self) : LoadingManager.hide()  // should work better to avoid presentation
            })                                                                  // logic inside view layer.
            .disposed(by: bag)

        viewModel.messageError
            .asObservable()
            .observeOn(MainScheduler())
            .subscribe(onNext: { [weak self] (message) in
                let alert = UIAlertController(
                    title: "Ops!",
                    message: message,
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
        
        viewModel.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: bag)
        
        collectionView.rx
            .itemSelected
            .asObservable()
            .bind { [weak self] (indexPath) in
                self?.viewModel.cellTriggered.onNext(indexPath.row)
            }
            .disposed(by: bag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .asObservable()
            .bind(to: viewModel.refreshTriggered)
            .disposed(by: bag)
    }
}

// Mark: CollectionView

extension ShipsListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width * 0.8 , height: self.view.frame.height * 0.5)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 40
    }

}
