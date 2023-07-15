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

        nameSurnameLabel.text = "\(request.name) \(request.surname)"
        emailLabel.text = request.email
        addressLabel.text = request.address
        phoneNumberLabel.text = request.phoneNumber
        
        acceptButton.layer.cornerRadius = 15
        rejectButton.layer.cornerRadius = 15
        
        detailsView.layer.cornerRadius = 20
    }
    
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
    }
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
    }
    
}
