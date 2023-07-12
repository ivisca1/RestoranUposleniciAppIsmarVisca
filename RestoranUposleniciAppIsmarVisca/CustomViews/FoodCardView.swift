//
//  FoodCardView.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 12. 7. 2023..
//

import UIKit

class FoodCardView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.cornerRadius = 20
    }
}
