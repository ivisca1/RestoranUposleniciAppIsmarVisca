//
//  FirstViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 30. 6. 2023..
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.layer.cornerRadius = 15
        logInButton.layer.cornerRadius = 15
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        let controller = LogInViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let controller = SignUpViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
}
