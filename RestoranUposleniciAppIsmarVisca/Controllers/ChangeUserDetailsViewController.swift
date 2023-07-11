//
//  ChangeUserDetailsViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 11. 7. 2023..
//

import UIKit
import Toast

class ChangeUserDetailsViewController: UIViewController {

    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var invalidAddressLabel: UILabel!
    @IBOutlet weak var invalidPhoneNumberLabel: UILabel!
    @IBOutlet weak var invalidSurnameLabel: UILabel!
    @IBOutlet weak var invalidNameLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let defaultColor = UIColor.lightGray.cgColor
    var shouldChangeDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpEverything()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        tryToChange()
    }
}

extension ChangeUserDetailsViewController : FoodManagerDelegate {
    
    func didUpdateUser(_ foodManager: FoodManager) {
        navigationController?.view.makeToast("Uspješno ažurirani podaci", duration: 2.0, position: .bottom)
        navigationController?.popViewController(animated: true)
    }
    
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didFetchOrders(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}

extension ChangeUserDetailsViewController : UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        if textField.tag == 3 {
            tryToChange()
            textField.endEditing(true)
            return true
        }
        
        return false
    }
}

extension ChangeUserDetailsViewController {
    
    @objc func nameTextFieldDidChange() {
        nameTextField.layer.borderColor = defaultColor
        nameTextField.layer.borderWidth = 0.25
        invalidNameLabel.isHidden = true
    }
    
    @objc func surnameTextFieldDidChange() {
        surnameTextField.layer.borderColor = defaultColor
        surnameTextField.layer.borderWidth = 0.25
        invalidSurnameLabel.isHidden = true
    }
    
    @objc func addressTextFieldDidChange() {
        addressTextField.layer.borderColor = defaultColor
        addressTextField.layer.borderWidth = 0.25
        invalidAddressLabel.isHidden = true
    }
    
    @objc func phoneNumberTextFieldDidChange() {
        phoneNumberTextField.layer.borderColor = defaultColor
        phoneNumberTextField.layer.borderWidth = 0.25
        invalidPhoneNumberLabel.isHidden = true
    }
    
    private func setUpEverything() {
        
        navigationController?.navigationBar.tintColor = UIColor.white

        let user = MyVariables.foodManager.user
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressTextField.delegate = self

        addressTextField.text = user?.address
        phoneNumberTextField.text = user?.phoneNumber
        surnameTextField.text = user?.surname
        nameTextField.text = user?.name
        
        nameTextField.tag = 0
        surnameTextField.tag = 1
        phoneNumberTextField.tag = 2
        addressTextField.tag = 3
        
        nameTextField.layer.cornerRadius = 15
        nameTextField.clipsToBounds = true
        surnameTextField.layer.cornerRadius = 15
        surnameTextField.clipsToBounds = true
        phoneNumberTextField.layer.cornerRadius = 15
        phoneNumberTextField.clipsToBounds = true
        addressTextField.layer.cornerRadius = 15
        addressTextField.clipsToBounds = true
        
        changeButton.layer.cornerRadius = 15
        
        invalidNameLabel.isHidden = true
        invalidSurnameLabel.isHidden = true
        invalidAddressLabel.isHidden = true
        invalidPhoneNumberLabel.isHidden = true
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(surnameTextFieldDidChange), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
    }
    
    private func tryToChange() {
        
        let name = nameTextField.text!
        let surname = surnameTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        let address = addressTextField.text!
        
        var nameValid = false
        if name.isEmpty == false {
            if containsOnlyLetters(str: name) {
                nameValid = true
            } else {
                textFieldInvalid("Ime treba da sadrži samo slova!", textField: nameTextField, label: invalidNameLabel)
            }
        } else {
            textFieldInvalid("Ime polje je obavezno!", textField: nameTextField, label: invalidNameLabel)
        }
        
        var surnameValid = false
        if surname.isEmpty == false {
            if containsOnlyLetters(str: surname) {
                surnameValid = true
            } else {
                textFieldInvalid("Prezime treba da sadrži samo slova!", textField: surnameTextField, label: invalidSurnameLabel)
            }
        } else {
            textFieldInvalid("Prezime polje je obavezno!", textField: surnameTextField, label: invalidSurnameLabel)
        }
        
        var phoneNumberValid = false
        if phoneNumber.isEmpty == false {
            if phoneNumber.isNumber {
                phoneNumberValid = true
            } else {
                textFieldInvalid("Broj telefona treba da sadrži samo brojeve!", textField: phoneNumberTextField, label: invalidPhoneNumberLabel)
            }
        } else {
            textFieldInvalid("Broj telefona polje je obavezno!", textField: phoneNumberTextField, label: invalidPhoneNumberLabel)
        }
        
        var addressValid = false
        if address.isEmpty == false {
            addressValid = true
        } else {
            textFieldInvalid("Adresa polje je obavezno!", textField: addressTextField, label: invalidAddressLabel)
        }
        
        if nameValid && surnameValid && phoneNumberValid && addressValid {
            MyVariables.foodManager.updateUser(name: name, surname: surname, phoneNumber: phoneNumber, address: address)
        }
    }
}
