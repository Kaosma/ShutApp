//
//  ContactsViewController.swift
//  ShutApp
//
//  Created by Erik Ugarte on 2020-11-27.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController {
    
    // MARK: Constants and Variables
    
    // Database initialization
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser!
    var contacts : [Contact] = []
    
    
    // MARK: IBOutlets
    @IBOutlet weak var contactTableView: UITableView!
    
    
    // MARK: IBActions
    // Adding another user to contacts
    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Contact", message: "Enter the contact's e-mail.", preferredStyle: .alert)
        
        // Creating an alert that allows the user to pass in a new contact's e-mail
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                let contactEmail = textField.text!
                let docRef = self.db.collection("users").document(contactEmail)
                
                docRef.getDocument { (document, error) in
                    // If the new contact's email exists -> Add them
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        if let contactId = dataDescription!["id"] as? String {
                            
                            // Add contact to the user's contacts in the database
                            let contactsCollection =
                                self.db.collection("users").document(self.currentUser.email!).collection("contacts")
                            contactsCollection.document(contactEmail).setData(["id": contactId as Any]) // <------------------
                            self.loadContactsFromDatabase()
                            let dismissAlert = UIAlertController(title: "Contact Added!", message: "", preferredStyle: .alert)
                            
                            dismissAlert.addAction(UIAlertAction(title: "OK",
                                                                 style: .cancel, handler: nil))

                            self.present(dismissAlert, animated: true, completion: nil)
                        }
                    // If the new contact's email doesn't exist -> Let the user know with an alert
                    } else {
                        let dismissAlert = UIAlertController(title: "User not found", message: "", preferredStyle: .alert)
                        
                        dismissAlert.addAction(UIAlertAction(title: "OK",
                                                             style: .cancel, handler: nil))

                        self.present(dismissAlert, animated: true, completion: nil)
                    }
                }
            } else {}
        }
        // Styling the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "john@doe.com"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Other Functions
    // Load the user's contacts into the TableView
    func loadContactsFromDatabase(){
        contacts = []
        let collection = db.collection("users").document(self.currentUser.email!).collection("contacts")
        collection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let contactID = document.data()["id"] as? String{
                        let contactEmail = document.documentID
                        let contact = Contact(email: contactEmail, id: contactID)
                        
                        self.contacts.append(contact)
                        DispatchQueue.main.async {
                            self.contactTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: Main Program
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        loadContactsFromDatabase()
    }

}


// MARK: TableView Functions
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return number of cells in tableview -> Size of the contacts Array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    // Creating each TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.email
        return cell
    }
    
    // Handling a selected TableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
