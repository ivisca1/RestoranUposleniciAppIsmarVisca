//
//  EmployeesReviewViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 14. 7. 2023..
//

import UIKit

class EmployeesReviewViewController: UIViewController {

    @IBOutlet weak var pullDownButton: UIButton!
    @IBOutlet weak var requestsCollectionView: UICollectionView!
    @IBOutlet weak var employeesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpEverything()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        if MyVariables.shouldRefreshEmployees {
            showSpinner(activityIndicator: MyVariables.activityIndicator)
            MyVariables.foodManager.fetchOtherUsersStatus(true)
            MyVariables.shouldRefreshEmployees = false
        }
    }
}

extension EmployeesReviewViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case employeesCollectionView:
            return MyVariables.foodManager.otherEmployees.count
        case requestsCollectionView:
            return MyVariables.foodManager.userRequests.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case employeesCollectionView:
            let cell = employeesCollectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
            cell.setup(user: MyVariables.foodManager.otherEmployees[indexPath.row])
            return cell
        case requestsCollectionView:
            let cell = requestsCollectionView.dequeueReusableCell(withReuseIdentifier: RequestCollectionViewCell.identifier, for: indexPath) as! RequestCollectionViewCell
            cell.setup(request: MyVariables.foodManager.userRequests[indexPath.row])
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
        if collectionView == requestsCollectionView {
            let controller = RequestReviewViewController.instantiate()
            controller.request = MyVariables.foodManager.userRequests[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension EmployeesReviewViewController : FoodManagerDelegate {
    func didFetchOtherEmployees(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        employeesCollectionView.reloadData()
        requestsCollectionView.reloadData()
    }
    
    func didFetchReservations(_ foodManager: FoodManager) {}
    func didRejectRequest(_ foodManager: FoodManager) {}
    func didAcceptRequest(_ foodManager: FoodManager) {}
    func didFetchOrders(_ foodManager: FoodManager) {}
    func didTakeOrder(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didFindUserForOrder(_ foodManager: FoodManager, user: User?) {}
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}

extension EmployeesReviewViewController {
    
    private func setUpEverything() {
        MyVariables.foodManager.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.fetchOtherUsersStatus(true)
        
        setupMenu()
        
        registerCells()
    }
    
    private func registerCells() {
        requestsCollectionView.register(UINib(nibName: RequestCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RequestCollectionViewCell.identifier)
        employeesCollectionView.register(UINib(nibName: UserCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
    }
    
    private func setupMenu() {
        let income = UIAction(title: "Ukupnu zaradu") { _ in
            self.pullDownButton.setTitle("Ukupnu zaradu", for: .normal)
            MyVariables.showIncome = true
            self.employeesCollectionView.reloadData()
        }
        
        let activity = UIAction(title: "Aktivnost") { _ in
            self.pullDownButton.setTitle("Aktivnost", for: .normal)
            MyVariables.showIncome = false
            self.employeesCollectionView.reloadData()
        }
        
        let menu = UIMenu(title: "Prikaži:", children: [income, activity])
        pullDownButton.menu = menu
        pullDownButton.showsMenuAsPrimaryAction = true
    }
}
