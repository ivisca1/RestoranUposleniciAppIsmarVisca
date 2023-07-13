//
//  HomeViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 10. 7. 2023..
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var refreshUsersImageView: UIImageView!
    @IBOutlet weak var refreshImageView: UIImageView!
    @IBOutlet weak var takenOrdersCollectionView: UICollectionView!
    @IBOutlet weak var waitingOrdersCollectionView: UICollectionView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEverything()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        if MyVariables.shouldRefreshOrders {
            showSpinner(activityIndicator: MyVariables.activityIndicator)
            MyVariables.foodManager.fetchOrders()
            MyVariables.shouldRefreshOrders = false
        }
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case userCollectionView:
            return MyVariables.foodManager.otherEmployees.count
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
            cell.setup(user: MyVariables.foodManager.otherEmployees[indexPath.row])
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
        if collectionView == waitingOrdersCollectionView {
            let controller = NewOrderViewController.instantiate()
            controller.order = MyVariables.foodManager.waitingOrders[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else if collectionView == takenOrdersCollectionView {
            let controller = TakenOrderViewController.instantiate()
            controller.order = MyVariables.foodManager.takenOrders[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension HomeViewController : FoodManagerDelegate {
    
    func didFetchOrders(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        waitingOrdersCollectionView.reloadData()
        takenOrdersCollectionView.reloadData()
    }
    
    func didFetchOtherEmployees(_ foodManager: FoodManager) {
        if MyVariables.activityIndicator.isAnimating {
            stopSpinner(activityIndicator: MyVariables.activityIndicator)
        }
        userCollectionView.reloadData()
    }
    
    func didTakeOrder(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didFindUserForOrder(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}

extension HomeViewController {
    
    private func setUpEverything() {
        MyVariables.foodManager.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(refreshTapped(tapGestureRecognizer:)))
        refreshImageView.isUserInteractionEnabled = true
        refreshImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerUsers = UITapGestureRecognizer(target: self, action: #selector(refreshUsersTapped(tapGestureRecognizer:)))
        refreshUsersImageView.isUserInteractionEnabled = true
        refreshUsersImageView.addGestureRecognizer(tapGestureRecognizerUsers)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 36)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.831, green: 0.765, blue: 0.51, alpha: 1.0)]
        
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.isAnyoneSignedIn()

        registerCells()
    }
    
    private func registerCells() {
        userCollectionView.register(UINib(nibName: UserCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        waitingOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
        takenOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
    }
    
    @objc func refreshTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchOrders()
    }
    
    @objc func refreshUsersTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchOtherUsersStatus()
    }
}
