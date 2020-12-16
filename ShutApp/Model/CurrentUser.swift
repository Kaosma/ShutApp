//
//  CurrentUser.swift
//  ShutApp
//
//  Created by Erik Ugarte on 2020-12-09.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import Foundation
import Firebase

// CurrentUser object
class CurrentUser {

    let db = Firestore.firestore()

    var email : String {
        var userEmail = ""
        if let fetchedEmail = Auth.auth().currentUser!.email {
            userEmail = fetchedEmail
        }
        return userEmail
    }
    
    var id : String {
        var userId = ""
        let fetchedId = Auth.auth().currentUser!.uid
        userId = fetchedId
        return userId

    }
    
    // Initiate the username

    var username : String = ""
    
    func setName(contactUserEmail: String, conversation: String) {
        let docRef = db.collection("users").document(Auth.auth().currentUser!.email!)
        var name = ""
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let dataDescription = document.data() {
                    if let userName = dataDescription["name"] as? String {
                        name = userName
                    }
                    DispatchQueue.main.async {
                        // Add contact to the user's contacts in the database
                        let contactsCollection = self.db.collection("users").document(contactUserEmail).collection("contacts")
                        contactsCollection.document(self.email).setData(["id" : self.id as String,
                                                                                "name" : name as String,
                                                                    "conversation" : conversation as String])
                        print(name)
                    }
                }
            }
        }
    }
}
