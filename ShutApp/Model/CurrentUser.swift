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

    

struct CurrentUser {

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

    var username : String {
        let docRef = self.db.collection("users").document(email)
        var name = ""
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                if let contactUsername: String = dataDescription!["name"] as? String {
                    name = contactUsername
                }
            }
        }
        return name
    }
}
