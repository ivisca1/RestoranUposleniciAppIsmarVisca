//
//  OrderCollectionViewCell.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 10. 7. 2023..
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var thirdDishView: ImageCardView!
    @IBOutlet weak var secondDishView: ImageCardView!
    @IBOutlet weak var thirdDishImage: UIImageView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var additionalFoodLabel: UILabel!
    @IBOutlet weak var secondDishImge: UIImageView!
    @IBOutlet weak var firstDishImage: UIImageView!
    static let identifier = "OrderCollectionViewCell"
    
    func setup(order: Order) {
        var totalPrice = 0
        
        for dish in order.food {
            totalPrice = totalPrice + (Int(dish.price.digits) ?? 0)
        }
        
        totalPriceLabel.text = "\(totalPrice) KM"
        
        if order.food.count == 1 {
            secondDishView.isHidden = true
            thirdDishView.isHidden = true
            additionalFoodLabel.isHidden = true
            firstDishImage.image = UIImage(named: order.food[0].image)
        } else if order.food.count == 2 {
            secondDishView.isHidden = false
            thirdDishView.isHidden = true
            additionalFoodLabel.isHidden = true
            firstDishImage.image = UIImage(named: order.food[0].image)
            secondDishImge.image = UIImage(named: order.food[1].image)
        } else if order.food.count == 3 {
            secondDishView.isHidden = false
            thirdDishView.isHidden = false
            additionalFoodLabel.isHidden = true
            firstDishImage.image = UIImage(named: order.food[0].image)
            secondDishImge.image = UIImage(named: order.food[1].image)
            thirdDishImage.image = UIImage(named: order.food[2].image)
        } else {
            secondDishView.isHidden = false
            thirdDishView.isHidden = false
            additionalFoodLabel.isHidden = false
            firstDishImage.image = UIImage(named: order.food[0].image)
            secondDishImge.image = UIImage(named: order.food[1].image)
            thirdDishImage.image = UIImage(named: order.food[2].image)
            additionalFoodLabel.text = "+\(order.food.count - 3)"
        }
    }
}
