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
    
    var contacts : [Contact] = []

    // Database initialization
    let db = Firestore.firestore()
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Signing up a user with e-mail and password
    @IBAction func signUpButton(_ sender: UIButton) {
        if let newEmail = emailTextField.text, let newPassword = passwordTextField.text,
           let confirmPassword = confirmPasswordTextField.text, let userName = usernameTextField.text {
            if newPassword == confirmPassword{
                Auth.auth().createUser(withEmail: newEmail, password: newPassword, completion: { authResult, error in
                    if let e = error {
                        print(e)
                        return
                    }
                    // Adding the user to the "users" collection in the database
                    guard let authResult = authResult else { return }
                    let user = authResult.user

                    let values = ["id": user.uid, "name": userName ]
                    self.db.collection("users").document(user.email!).setData(values as Any as! [String : Any]) // <------------
                    
                })
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
