//
//  SignUpViewController.swift
//  ShutApp
//
//  Created by Alexander Jansson on 2020-11-26.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if let newEmail = emailTextField.text, let newPassword = passwordTextField.text,
           let confirmPassword = confirmPasswordTextField.text {
            
            if newPassword == confirmPassword{
                Auth.auth().createUser(withEmail: newEmail, password: newPassword) { authResult, error in
                    print()
                    print(authResult as Any)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
