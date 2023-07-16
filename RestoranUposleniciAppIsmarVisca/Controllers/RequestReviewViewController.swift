//
//  RequestReviewViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 14. 7. 2023..
//

import UIKit

class RequestReviewViewController: UIViewController {

    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var request : Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DA")
        MyVariables.foodManager.delegate = self

        nameSurnameLabel.text = "\(request.name) \(request.surname)"
        emailLabel.text = request.email
        addressLabel.text = request.address
        phoneNumberLabel.text = request.phoneNumber
        
        acceptButton.layer.cornerRadius = 15
        rejectButton.layer.cornerRadius = 15
        
        detailsView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.rejectRequest(email: request.email)
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        showSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.foodManager.acceptRequest(request: request)
    }
    
}

extension RequestReviewViewController : FoodManagerDelegate {
    func didRejectRequest(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.shouldRefreshEmployees = true
        navigationController!.view.makeToast("Uspješno odbijen zahtjev!", duration: 2.0, position: .bottom)
        navigationController!.popViewController(animated: true)
    }
    
    func didAcceptRequest(_ foodManager: FoodManager) {
        stopSpinner(activityIndicator: MyVariables.activityIndicator)
        MyVariables.shouldRefreshEmployees = true
        MyVariables.foodManager.logOutLogIn()
        navigationController!.view.makeToast("Uspješno prihvaćen zahtjev!", duration: 2.0, position: .bottom)
        navigationController!.popViewController(animated: true)
    }
    
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didFetchOtherEmployees(_ foodManager: FoodManager) {}
    func didTakeOrder(_ foodManager: FoodManager) {}
    func didDeliverOrder(_ foodManager: FoodManager) {}
    func didFindUserForOrder(_ foodManager: FoodManager, user: User?) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didFetchOrders(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}
