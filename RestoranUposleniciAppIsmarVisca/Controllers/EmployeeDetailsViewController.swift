//
//  EmployeeDetailsViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 15. 8. 2023..
//

import UIKit

class EmployeeDetailsViewController: UIViewController {

    @IBOutlet weak var takenOrdersCollectionView: UICollectionView!
    @IBOutlet weak var finishedOrdersCollectionView: UICollectionView!
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(user.name) \(user.surname)"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26), NSAttributedString.Key.foregroundColor: UIColor.white]

        MyVariables.foodManager.delegate = self
        
        registerCells()
        
        MyVariables.foodManager.fetchOrdersForUse(user: user)
        
        showSpinner(activityIndicator: MyVariables.activityIndicator)
    }
    
    private func registerCells() {
        finishedOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
        takenOrdersCollectionView.register(UINib(nibName: OrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
    }
    
}

extension EmployeeDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case takenOrdersCollectionView:
            return MyVariables.foodManager.takenOrdersForUser.count
        case finishedOrdersCollectionView:
            return MyVariables.foodManager.finishedOrdersForUser.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case takenOrdersCollectionView:
            let cell = takenOrdersCollectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as! OrderCollectionViewCell
            cell.setup(order: MyVariables.foodManager.takenOrdersForUser[indexPath.row])
            return cell
        case finishedOrdersCollectionView:
            let cell = finishedOrdersCollectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as! OrderCollectionViewCell
            cell.setup(order: MyVariables.foodManager.finishedOrdersForUser[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            collectionView.cellForItem(at: indexPath)?.alpha = 1
        }
        if collectionView == finishedOrdersCollectionView {
            let controller = FinishedOrderViewController.instantiate()
            controller.order = MyVariables.foodManager.finishedOrders[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension EmployeeDetailsViewController : FoodManagerDelegate {
    
    func didFetchOrders(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        takenOrdersCollectionView.reloadData()
        finishedOrdersCollectionView.reloadData()
    }
    
    func didFetchReservations(_ foodManager: FoodManager) {}
    func didRejectRequest(_ foodManager: FoodManager) {}
    func didAcceptRequest(_ foodManager: FoodManager) {}
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
