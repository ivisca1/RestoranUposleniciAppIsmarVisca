//
//  OrderCollectionViewCell.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 10. 7. 2023..
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var additionalFoodLabel: UILabel!
    @IBOutlet weak var secondDishImge: UIImageView!
    @IBOutlet weak var firstDishImage: UIImageView!
    static let identifier = "OrderCollectionViewCell"
    
    func setup() {
        
    }
}
