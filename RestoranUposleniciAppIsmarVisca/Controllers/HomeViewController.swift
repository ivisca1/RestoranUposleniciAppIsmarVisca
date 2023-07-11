//
//  HomeViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 10. 7. 2023..
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var takenOrdersCollectionView: UICollectionView!
    @IBOutlet weak var waitingOrdersCollectionView: UICollectionView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    var timer = Timer()
    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyVariables.foodManager.delegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 36)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.831, green: 0.765, blue: 0.51, alpha: 1.0)]
        
        MyVariables.foodManager.isAnyoneSignedIn()

        registerCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            if self.firstTime {
                self.firstTime = false
            } else {
                MyVariables.foodManager.fetchOrders()
            }
        })
    }
    
    private func registerCells() {
        userCollectionView.register(UINib(nibName: UserCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        waitingOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
        takenOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case userCollectionView:
            return 10
        case waitingOrdersCollectionView:
            return MyVariables.foodManager.waitingOrders.count
        case takenOrdersCollectionView:
            return MyVariables.foodManager.takenOrders.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case userCollectionView:
            let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
            cell.setup()
            return cell
        case waitingOrdersCollectionView:
            let cell = waitingOrdersCollectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as! OrderCollectionViewCell
            cell.setup(order: MyVariables.foodManager.waitingOrders[indexPath.row])
            return cell
        case takenOrdersCollectionView:
            let cell = takenOrdersCollectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as! OrderCollectionViewCell
            cell.setup(order: MyVariables.foodManager.takenOrders[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController : FoodManagerDelegate {
    
    func didFetchOrders(_ foodManager: FoodManager) {
        waitingOrdersCollectionView.reloadData()
        takenOrdersCollectionView.reloadData()
    }
    
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}
