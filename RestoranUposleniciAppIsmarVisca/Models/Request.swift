//
//  Request.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 14. 7. 2023..
//

import Foundation

struct Request {
    var name, surname, phoneNumber, email, address : String
    var orderNumber : Int
    var isCustomer, isEmployee, isAdmin : Bool
    var status, password : String
}
