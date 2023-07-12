//
//  MyVariables.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 9. 7. 2023..
//

import UIKit

struct MyVariables {
    static var foodManager = FoodManager()
    static let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 0.922, green: 0.294, blue: 0.302, alpha: 1.0)
        return activityIndicator
    }()
    static var shouldRefreshOrders = false
}

func textFieldInvalid(_ msg: String, textField: UITextField!, label: UILabel!) {
    let redColor = UIColor.red.cgColor
    textField.layer.borderColor = redColor
    textField.layer.borderWidth = 1.0
    label.text = msg
    label.isHidden = false
}

func containsOnlyLetters(str: String) -> Bool {
   for chr in str {
      if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr=="ć") && !(chr=="Ć") && !(chr=="č") && !(chr=="Č") && !(chr=="ž") && !(chr=="Ž") && !(chr=="š") && !(chr=="Š") && !(chr=="đ") && !(chr=="Đ")) {
         return false
      }
   }
   return true
}
