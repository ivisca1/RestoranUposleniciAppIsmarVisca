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
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        MyVariables.foodManager.fetchFood()

        signUpButton.layer.cornerRadius = 15
        logInButton.layer.cornerRadius = 15
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        let controller = LogInViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
        let controller = SignUpViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
}
