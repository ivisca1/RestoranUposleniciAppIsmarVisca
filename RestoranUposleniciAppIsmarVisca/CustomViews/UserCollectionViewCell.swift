//
//  UserCollectionViewCell.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 10. 7. 2023..
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    static let identifier = "UserCollectionViewCell"

    @IBOutlet weak var userActivityLabel: UILabel!
    @IBOutlet weak var userNameSurname: UILabel!
    
    func setup(user: User) {
        if user.status == "Neaktivan" {
            userActivityLabel.textColor = UIColor.red
        } else if user.status == "Pauza" {
            userActivityLabel.textColor = UIColor.yellow
        } else if user.status == "Aktivan" {
            userActivityLabel.textColor = UIColor.green
        }
        userActivityLabel.text = user.status
        userNameSurname.text = "\(user.name) \(user.surname)"
    }
}
