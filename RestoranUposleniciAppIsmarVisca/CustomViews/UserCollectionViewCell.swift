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
    @IBOutlet weak var userImageView: UIImageView!
    
    func setup() {
        
    }
}
