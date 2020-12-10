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
    @IBOutlet weak var EmailTextField: UITextField!
    let currentUser = CurrentUser()
    let db = Firestore.firestore()
    @IBOutlet weak var nameTextField: UILabel!
    
    
    //Change email and you will get a confirmation to your email
   /* @IBAction func changeEmailButton(_ sender: UIButton) {
        Auth.auth().currentUser?.updateEmail(to: EmailTextField.text!, completion: { (error) in
           if error != nil {
           print("Firebase Change Email Error: \(String(describing: error))")
           } else {
           print("Firebase Change Email Successful")
            //            self.db.collection("users").document(self.currentUser.email!).updateData( [EmailTextField.text! : Any])

            }
        })
    
    }*/
        

    
    //Change password by reset link
    @IBAction func changePasswordButton(_ sender: UIButton) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: currentUser.email) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "Done", message: "A password reset has been sent!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in self.performSegue(withIdentifier: "signOutBackToLogin", sender: self) }))
            self.present(alert, animated: true, completion: nil)
            do {
                try Auth.auth().signOut()
                } catch let err {
                    print(err)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Getting the username from the current logged in user
        let collection = db.collection("users").document(self.currentUser.email)
        collection.getDocument { (document, err) in
            if let document = document, document.exists {
                    let dataDescription = document.data()
                self.nameTextField.text = dataDescription?["name"] as? String
                self.EmailTextField.text = self.currentUser.email

                } else {
                    print("Document does not exist")
                }
            
        }
    }
    
    
    //sign out user
    @IBAction func signOutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signOutBackToLogin", sender: self)
            } catch let err {
                print(err)
        }
    }
    
}
