//
//  OrdersReviewViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 14. 7. 2023..
//

import UIKit

class OrdersReviewViewController: UIViewController {

    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var refreshFinishedOrdersImageView: UIImageView!
    @IBOutlet weak var refreshWaitingOrdersImageView: UIImageView!
    @IBOutlet weak var finishedOrdersCollectionView: UICollectionView!
    @IBOutlet weak var waitingOrdersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEverything()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
}

extension OrdersReviewViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case waitingOrdersCollectionView:
            return MyVariables.foodManager.waitingOrders.count
        case finishedOrdersCollectionView:
            return MyVariables.foodManager.finishedOrders.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case waitingOrdersCollectionView:
            let cell = waitingOrdersCollectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as! OrderCollectionViewCell
            cell.setup(order: MyVariables.foodManager.waitingOrders[indexPath.row])
            return cell
        case finishedOrdersCollectionView:
            let cell = finishedOrdersCollectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as! OrderCollectionViewCell
            cell.setup(order: MyVariables.foodManager.finishedOrders[indexPath.row])
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
        } else if collectionView == finishedOrdersCollectionView {
            let controller = FinishedOrderViewController.instantiate()
            controller.order = MyVariables.foodManager.finishedOrders[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension OrdersReviewViewController : FoodManagerDelegate {
    func didFetchOrders(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        waitingOrdersCollectionView.reloadData()
        finishedOrdersCollectionView.reloadData()
        var totalPrice = 0
        for order in MyVariables.foodManager.finishedOrders {
            for dish in order.food {
                totalPrice = totalPrice + (Int(dish.price.digits) ?? 0)
            }
        }
        totalIncomeLabel.text = "\(totalPrice) KM"
    }
    
    func didFetchOtherEmployees(_ foodManager: FoodManager) {}
    func didTakeOrder(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didFindUserForOrder(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}

extension OrdersReviewViewController {
    
    private func setUpEverything() {
        MyVariables.foodManager.delegate = self

        navigationController?.navigationBar.tintColor = UIColor.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(refreshWaitingOrdersTapped(tapGestureRecognizer:)))
        refreshWaitingOrdersImageView.isUserInteractionEnabled = true
        refreshWaitingOrdersImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerUsers = UITapGestureRecognizer(target: self, action: #selector(refreshFinishedOrdersTapped(tapGestureRecognizer:)))
        refreshFinishedOrdersImageView.isUserInteractionEnabled = true
        refreshFinishedOrdersImageView.addGestureRecognizer(tapGestureRecognizerUsers)
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Pregled Narudžbi"
        label.font = label.font.withSize(26)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchOrders()
        
        registerCells()
    }
    
    private func registerCells() {
        waitingOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
        finishedOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
    }
    
    @objc func refreshWaitingOrdersTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchOrders()
    }
    
    @objc func refreshFinishedOrdersTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchOrders()
    }
}
