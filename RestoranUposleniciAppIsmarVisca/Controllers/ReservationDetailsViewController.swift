//
//  ReservationDetailsViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 20. 7. 2023..
//

import UIKit

class ReservationDetailsViewController: UIViewController {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var reservation : Reservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsView.layer.cornerRadius = 20
        
        dateLabel.text = "\(reservation.day)/\(reservation.month)/\(reservation.year)"
        timeLabel.text = "\(reservation.hours):00"
        numberOfPeopleLabel.text = "\(reservation.numberOfPeople)"
        nameSurnameLabel.text = "\(MyVariables.foodManager.user!.name) \(MyVariables.foodManager.user!.surname)"
        commentLabel.text = reservation.comment
    }
    
    
}
