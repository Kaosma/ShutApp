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
    var contacts : [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserInfo()

        
    }
    
    // Authenticating and login the user
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let inputEmail = emailTextField.text, let inputPassword = passwordTextField.text {
            Auth.auth().signIn(withEmail: inputEmail, password: inputPassword) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self!.performSegue(withIdentifier: "GoToContactsScreen", sender: self)
                    //print("Logged in user! name: \(String(describing: contacts.name))")
                }
            }
        }
    }
    
    func checkUserInfo(){
        if ((Auth.auth().currentUser?.uid) != nil) {
            print(Auth.auth().currentUser?.uid as Any)
            self.performSegue(withIdentifier: "GoToContactsScreen", sender: self)
        }
    }
    
}


