//
//  FoodManager.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 1. 7. 2023..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FoodManagerDelegate {
    func didLogOutUser(_ foodManager: FoodManager)
    func didSignInUser(_ foodManager: FoodManager, user: User?)
    func didFailWithError(error: String)
}

class FoodManager {
    
    let db = Firestore.firestore()
    
    var delegate : FoodManagerDelegate?
    
    var user : User?
    
    func createUserWithoutSignIn(userToCreate: User) {
        
    }
    
    func createUser(userToCreate : User, password: String) {
        self.db.collection("requests").whereField("email", isEqualTo: userToCreate.email)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    self.db.collection("users").whereField("email", isEqualTo: userToCreate.email)
                        .getDocuments() { (querySnapshot, err) in
                            if err == nil {
                                let foundUser = querySnapshot?.documents[0]
                                let isEmployee = foundUser?.data()["isEmployee"] as! Bool
                                let isCustomer = foundUser?.data()["isCustomer"] as! Bool
                                if isCustomer && !isEmployee {
                                    self.createNewRequest(userToCreate, password: password)
                                } else {
                                    let errorMsg = "Profil sa ovim email-om već postoji!"
                                    self.delegate?.didFailWithError(error: errorMsg)
                                }
                            } else {
                                self.createNewRequest(userToCreate, password: password)
                            }
                    }
                } else {
                    let errorMsg = "Već ste poslali zahtjev za kreiranje profila!"
                    self.delegate?.didFailWithError(error: errorMsg)
                }
        }
    }
    
    private func createNewRequest(_ userToCreate: User, password: String) {
        self.db.collection("requests").document(userToCreate.email).setData([
            "name": userToCreate.name,
            "surname": userToCreate.surname,
            "email": userToCreate.email,
            "address": userToCreate.address,
            "phoneNumber": userToCreate.phoneNumber,
            "orderNumber": 0,
            "isCustomer": true,
            "isEmployee": true,
            "isAdmin": false,
            "password": password
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                //self.ordered = false
                self.user = userToCreate
                self.delegate?.didSignInUser(self, user: userToCreate)
            }
        }
    }
    
    func logInUser(email: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,completion: { result, error in
            if error != nil {
                let errCode = AuthErrorCode(_nsError: error! as NSError)
                var errorMsg = ""
                switch errCode.code {
                case .userNotFound:
                    errorMsg = "Korisnik nije pronađen. Prvo kreirajte profil!"
                case .wrongPassword:
                    errorMsg = "Šifra neispravna!"
                default:
                    errorMsg = "Neuspješan Log In!"
                }
                self.delegate?.didFailWithError(error: errorMsg)
            }
            else {
                self.db.collection("users").whereField("email", isEqualTo: email)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let foundUser = querySnapshot?.documents[0]
                            let isEmployee = foundUser?.data()["isEmployee"] as! Bool
                            if isEmployee {
                                self.user = User(name: foundUser?.data()["name"] as! String, surname: foundUser?.data()["surname"] as! String, phoneNumber: foundUser?.data()["phoneNumber"] as! String, email: foundUser?.data()["email"] as! String, address: foundUser?.data()["address"] as! String, orderNumber: foundUser?.data()["orderNumber"] as! Int, isCustomer: foundUser?.data()["isCustomer"] as! Bool, isEmployee: foundUser?.data()["isEmployee"] as! Bool, isAdmin: foundUser?.data()["isAdmin"] as! Bool)
                                self.delegate?.didSignInUser(self, user: self.user!)
                            } else {
                                let errorMsg = "Korisnik nije pronađen. Prvo kreirajte profil!"
                                self.delegate?.didFailWithError(error: errorMsg)
                            }
                        }
                }
            }
        })
    }
    
    func logOutUser() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            user = nil
            self.delegate?.didLogOutUser(self)
        } catch {
            print("An error occurred")
        }
    }
    
    func isAnyoneSignedIn() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            self.db.collection("users").whereField("email", isEqualTo: FirebaseAuth.Auth.auth().currentUser!.email!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let foundUser = querySnapshot?.documents[0]
                        self.user = User(name: foundUser?.data()["name"] as! String, surname: foundUser?.data()["surname"] as! String, phoneNumber: foundUser?.data()["phoneNumber"] as! String, email: foundUser?.data()["email"] as! String, address: foundUser?.data()["address"] as! String, orderNumber: foundUser?.data()["orderNumber"] as! Int, isCustomer: foundUser?.data()["isCustomer"] as! Bool, isEmployee: foundUser?.data()["isEmployee"] as! Bool, isAdmin: foundUser?.data()["isAdmin"] as! Bool)
                        self.delegate?.didSignInUser(self, user: self.user!)
                        //self.fetchBasket()
                    }
            }
        } else {
            self.delegate?.didSignInUser(self, user: nil)
        }
    }
}
