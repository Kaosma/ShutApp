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

    let currentUser = Auth.auth().currentUser!
    let db = Firestore.firestore()
    @IBOutlet weak var nameTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting the username from the current logged in user
        let collection = db.collection("users").document(self.currentUser.email!)
        collection.getDocument { (document, err) in
            if let document = document, document.exists {
                    let dataDescription = document.data()
                self.nameTextField.text = dataDescription?["name"] as? String
                } else {
                    print("Document does not exist")
                }
            
        }
    }
    
    //sign out user
    @IBAction func signOutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            } catch let err {
                print(err)
        }
    }
    
}
