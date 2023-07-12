//
//  FoodDishViewCell.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 12. 7. 2023..
//

import UIKit

class FoodDishViewCell: UITableViewCell {

    static let identifier = String(describing: FoodDishViewCell.self)
    
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    func setup(food : FoodDish) {
        foodPriceLabel.text = food.price
        foodNameLabel.text = food.name
        foodImageView.image = UIImage(named: food.image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
}
