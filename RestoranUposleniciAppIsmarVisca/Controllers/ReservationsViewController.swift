//
//  ReservationsViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 20. 7. 2023..
//

import UIKit

class ReservationsViewController: UIViewController {

    @IBOutlet weak var reservationsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        registerCells()

        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchReservations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    private func registerCells() {
        reservationsCollectionView.register(UINib(nibName: ReservationCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ReservationCollectionViewCell.identifier)
    }
}

extension ReservationsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyVariables.foodManager.reservations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationCollectionViewCell.identifier, for: indexPath) as! ReservationCollectionViewCell
        cell.setup(reservation: MyVariables.foodManager.reservations[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ReservationDetailsViewController.instantiate()
        controller.reservation = MyVariables.foodManager.reservations[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ReservationsViewController : FoodManagerDelegate {
    func didFetchReservations(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        reservationsCollectionView.reloadData()
    }
    
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
    func didRejectRequest(_ foodManager: FoodManager) {}
    func didAcceptRequest(_ foodManager: FoodManager) {}
    func didFetchOtherEmployees(_ foodManager: FoodManager) {}
    func didTakeOrder(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didFindUserForOrder(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didFetchOrders(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
}
