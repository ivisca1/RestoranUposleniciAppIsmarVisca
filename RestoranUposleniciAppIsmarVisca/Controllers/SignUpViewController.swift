//
//  SignUpViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 30. 6. 2023..
//

import UIKit
import Toast

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var invalidPasswordAgainLabel: UILabel!
    @IBOutlet weak var invalidPasswordLabel: UILabel!
    @IBOutlet weak var invalidAddressLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var invalidPhoneNumberLabel: UILabel!
    @IBOutlet weak var invalidSurnameLabel: UILabel!
    @IBOutlet weak var invalidNameLabel: UILabel!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let defaultColor = UIColor.lightGray.cgColor
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 0.922, green: 0.294, blue: 0.302, alpha: 1.0)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpEverything()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        tryToSignUp()
    }
}

extension SignUpViewController : FoodManagerDelegate {
    func didSignInUser(_ foodManager: FoodManager, user: User?) {
        navigationController?.view.makeToast("Zahtjev poslan!", duration: 2.0, position: .bottom)
    }
    
    func didFailWithError(error: String) {
        stopSpinner()
        textFieldInvalid(error, textField: emailTextField, label: invalidEmailLabel)
    }
    
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {}
    func didFetchOrders(_ foodManager: FoodManager) {}
    func didLogOutUser(_ foodManager: FoodManager) {}
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
       } else {
           textField.resignFirstResponder()
       }
       
       if textField.tag == 6 {
           tryToSignUp()
           textField.endEditing(true)
           return true
       }
       
       return false
   }
}

extension SignUpViewController {
    
    @objc func emailTextFieldDidChange() {
        emailTextField.layer.borderColor = defaultColor
        emailTextField.layer.borderWidth = 0.25
        invalidEmailLabel.isHidden = true
    }
    
    @objc func passwordTextFieldDidChange() {
        passwordTextField.layer.borderColor = defaultColor
        passwordTextField.layer.borderWidth = 0.25
        invalidPasswordLabel.isHidden = true
    }
    
    @objc func passwordAgainTextFieldDidChange() {
        passwordAgainTextField.layer.borderColor = defaultColor
        passwordAgainTextField.layer.borderWidth = 0.25
        invalidPasswordAgainLabel.isHidden = true
    }
    
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
        
        self.hideKeyboardWhenTappedAround()
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        
        nameTextField.tag = 0
        surnameTextField.tag = 1
        phoneNumberTextField.tag = 2
        emailTextField.tag = 3
        addressTextField.tag = 4
        passwordTextField.tag = 5
        passwordAgainTextField.tag = 6
        
        nameTextField.layer.cornerRadius = 15
        nameTextField.clipsToBounds = true
        surnameTextField.layer.cornerRadius = 15
        surnameTextField.clipsToBounds = true
        phoneNumberTextField.layer.cornerRadius = 15
        phoneNumberTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        addressTextField.layer.cornerRadius = 15
        addressTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        passwordAgainTextField.layer.cornerRadius = 15
        passwordAgainTextField.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = 15
        
        invalidEmailLabel.isHidden = true
        invalidPasswordLabel.isHidden = true
        invalidPasswordAgainLabel.isHidden = true
        invalidNameLabel.isHidden = true
        invalidSurnameLabel.isHidden = true
        invalidAddressLabel.isHidden = true
        invalidPhoneNumberLabel.isHidden = true
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        passwordAgainTextField.addTarget(self, action: #selector(passwordAgainTextFieldDidChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(surnameTextFieldDidChange), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
    }
    
    private func tryToSignUp() {
        
        let name = nameTextField.text!
        let surname = surnameTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        let email = emailTextField.text!
        let address = addressTextField.text!
        let password = passwordTextField.text!
        let passwordAgain = passwordAgainTextField.text!
        
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
        
        var emailValid = false
        if email.isEmpty == false {
            if email.isValid(String.ValidityType.email) {
                emailValid = true
            } else {
                textFieldInvalid("Format email adrese nije validan!",textField: emailTextField, label: invalidEmailLabel)
            }
        } else {
            textFieldInvalid("Email polje je obavezno!",textField: emailTextField, label: invalidEmailLabel)
        }
        
        var addressValid = false
        if address.isEmpty == false {
            addressValid = true
        } else {
            textFieldInvalid("Adresa polje je obavezno!", textField: addressTextField, label: invalidAddressLabel)
        }
        
        var passwordValid = false
        if password.isEmpty == false {
            if password.count < 6 {
                textFieldInvalid("Šifra mora imati bar 6 karaktera!", textField: passwordTextField, label: invalidPasswordLabel)
            } else {
                passwordValid = true
            }
        } else {
            textFieldInvalid("Šifra polje je obavezno!", textField: passwordTextField, label: invalidPasswordLabel)
        }
        
        if passwordAgain.isEmpty == false {
            if password == passwordAgain {
                if nameValid && surnameValid && phoneNumberValid && addressValid && emailValid && passwordValid {
                    let request = User(name: name, surname: surname, phoneNumber: phoneNumber, email: email, address: address, orderNumber: 0, isCustomer: true, isEmployee: true, isAdmin: false)
                    showSpinner()
                    MyVariables.foodManager.createUser(userToCreate: request, password: password)
                }
            } else {
                if passwordValid {
                    textFieldInvalid("Šifre se ne podudaraju!", textField: passwordTextField, label: invalidPasswordLabel)
                }
                textFieldInvalid("Šifre se ne podudaraju!", textField: passwordAgainTextField, label: invalidPasswordAgainLabel)
            }
        } else {
            textFieldInvalid("Potvrdi Šifru polje je obavezno!", textField: passwordAgainTextField, label: invalidPasswordAgainLabel)
        }
    }
    
    private func showSpinner() {
        
        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)
            
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
            
        self.view.layoutSubviews()
    }
    
    private func stopSpinner() {
        
        activityIndicator.stopAnimating()
        
        activityIndicator.removeFromSuperview()
    }
}
