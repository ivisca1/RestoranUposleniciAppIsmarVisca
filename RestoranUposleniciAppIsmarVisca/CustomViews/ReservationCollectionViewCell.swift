//
//  ReservationCollectionViewCell.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 20. 7. 2023..
//

import UIKit

class ReservationCollectionViewCell: UICollectionViewCell {

    static let identifier = "ReservationCollectionViewCell"

    @IBOutlet weak var detailsLabel: UILabel!
    
    func setup(reservation: Reservation) {
        detailsLabel.text = "\(reservation.day)/\(reservation.month)/\(reservation.year), \(reservation.hours):00, \(reservation.numberOfPeople)"
    }
}
