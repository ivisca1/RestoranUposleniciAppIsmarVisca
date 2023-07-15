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
        if MyVariables.showIncome {
            var totalPrice = 0
            for order in MyVariables.foodManager.finishedOrders.filter( { $0.deliveryMan == user.email } ) {
                for dish in order.food {
                    totalPrice = totalPrice + (Int(dish.price.digits) ?? 0)
                }
            }
            userActivityLabel.textColor = UIColor(red: 0.922, green: 0.294, blue: 0.302, alpha: 1.0)
            userActivityLabel.text = "\(totalPrice) KM"
        } else {
            if user.status == "Neaktivan" {
                userActivityLabel.textColor = UIColor.red
            } else if user.status == "Pauza" {
                userActivityLabel.textColor = UIColor.yellow
            } else if user.status == "Aktivan" {
                userActivityLabel.textColor = UIColor.green
            }
            userActivityLabel.text = user.status
        }
        userNameSurname.text = "\(user.name) \(user.surname)"
    }
}
