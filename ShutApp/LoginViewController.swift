//
//  ViewController.swift
//  ShutApp
//
//  Created by Erik Ugarte on 2020-11-25.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let inputEmail = emailTextField.text, let inputPassword = passwordTextField.text {
            Auth.auth().signIn(withEmail: inputEmail, password: inputPassword) { [weak self] authResult, error in
                guard self != nil else {
                    print()
                    print("NOT LOGGED IN!")
                    return
                }
                print()
                print("LOGGED IN!")
            }
        }
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        if let newEmail = emailTextField.text, let newPassword = passwordTextField.text {
            Auth.auth().createUser(withEmail: newEmail, password: newPassword) { authResult, error in
                print()
                print("SIGNED UP!")
            }
        }
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

