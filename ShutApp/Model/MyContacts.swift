//
//  MyContacts.swift
//  ShutApp
//
//  Created by Erik Ugarte on 2020-12-09.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import Foundation
import Firebase

// Class containing the logged in user's contacts

class MyContacts {
    let db = Firestore.firestore()
    let currentUser = CurrentUser()
    
    var filteredContacts : [Contact] = []
    var contacts : [Contact] = []
    
    // Filtering the contacts when using the SearchBar
    func filterContacts(tableView: UITableView) {
        filteredContacts = []
        for contact in contacts {
            filteredContacts.append(contact)
        }
    }
    
    // Loading the contacts from the database
    func getContactsFromDatabase(tableView: UITableView, filter: Bool) {
        contacts = []
        let collection = db.collection("users").document(currentUser.email).collection("contacts")
        collection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let contactID = document.data()["id"] as? String, let contactUsername = document.data()["name"] as? String{
                        let contactEmail = document.documentID
                        let contact = Contact(username: contactUsername, email: contactEmail, id: contactID)
                        self.contacts.append(contact)
                        
                        if filter {
                            self.filterContacts(tableView: tableView)
                        }
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
