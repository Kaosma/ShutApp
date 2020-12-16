//
//  SettingsViewController.swift
//  ShutApp
//
//  Created by Alexander Jansson on 2020-11-30.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    var credential: AuthCredential?
    //@IBOutlet weak var EmailTextField: UITextField!
    let currentUser = CurrentUser()
    let db = Firestore.firestore()
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    
    //Delete user Button
    @IBAction func pressedDeleteButton(_ sender: UIButton) {
        self.currentUser.deleteUser()        
    }
    
    //Reset password button
    @IBAction func changePasswordButton(_ sender: UIButton) {
            self.currentUser.resetPassWordCurrentUser()
            let alert = UIAlertController(title: "Done", message: "A password reset has been sent!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in self.performSegue(withIdentifier: "signOutBackToLogin", sender: self) }))
            self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.layer.borderWidth = 1.5
        deleteButton.layer.borderColor = UIColor.black.cgColor
        
        // Getting the username from the current logged in user
        let collection = db.collection("users").document(self.currentUser.email)
        collection.getDocument { (document, err) in
            if let document = document, document.exists {
                    let dataDescription = document.data()
                self.nameTextField.text = dataDescription?["name"] as? String
                //self.EmailTextField.text = self.currentUser.email

                } else {
                    print("Document does not exist")
                }
            
        }
    }
    
    //Button for sign out user
    @IBAction func signOutButton(_ sender: UIButton) {
        self.currentUser.signOutCurrentUser()
        self.performSegue(withIdentifier: "signOutBackToLogin", sender: self)
    }
    
}
