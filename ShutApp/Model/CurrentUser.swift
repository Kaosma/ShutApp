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
    
    //deleting Current User Auth
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            print(error)          }
            else {
            print("User was successfully deleted")
          }
        }
        
        //deleting current user from users Collection
        let docRef = self.db.collection("users").document(email)
        docRef.delete { error in
          if let error = error {
            print(error)            }
            else {
                print("User was successfully deleted")
          }
        }
    }
    
    //SignOUt Current User
    func signOutCurrentUser() {
        do {
            try Auth.auth().signOut()
            } catch let err {
                print(err)
        }
    }
    
    //Reset CurrentUser Input
    func resetPassWordCurrentUser() {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: Auth.auth().currentUser!.email!) { (error) in
            if let error = error {
                print(error)
                return
            }else{
                print("Password was sent successfully")
            }
            do {
                try Auth.auth().signOut()
                } catch let err {
                    print(err)
            }
        }
    }
}
