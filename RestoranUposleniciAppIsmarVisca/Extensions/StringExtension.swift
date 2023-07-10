//
//  StringExtension.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 9. 7. 2023..
//

import UIKit

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    enum ValidityType {
        case email
    }
    
    enum Regex : String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validityType {
        case .email:
            regex = Regex.email.rawValue
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$",
            options: .regularExpression) != nil
    }
}
