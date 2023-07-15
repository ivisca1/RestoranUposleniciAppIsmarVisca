//
//  RequestCollectionViewCell.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 15. 7. 2023..
//

import UIKit

class RequestCollectionViewCell: UICollectionViewCell {

    static let identifier = "RequestCollectionViewCell"
    
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    func setup(request : Request) {
        nameSurnameLabel.text = "\(request.name) \(request.surname)"
    }
}
