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
    var filteredContacts : [Contact] = []
    
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
                
                if contactEmail != self.currentUser.email {
                    let docRef = self.db.collection("users").document(contactEmail)
                    
                    docRef.getDocument { (document, error) in
                        // If the new contact's email exists -> Add them
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            if let contactId = dataDescription!["id"] as? String, let contactUsername = dataDescription!["name"] as? String {
                                
                                // Add contact to the user's contacts in the database
                                let contactsCollection =
                                    self.db.collection("users").document(self.currentUser.email!).collection("contacts")
                                contactsCollection.document(contactEmail).setData(["id": contactId as Any, "name": contactUsername as Any])
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
                } else {
                    let dismissAlert = UIAlertController(title: "User not found", message: "", preferredStyle: .alert)
                    
                    dismissAlert.addAction(UIAlertAction(title: "OK",
                                                         style: .cancel, handler: nil))

                    self.present(dismissAlert, animated: true, completion: nil)
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
    
    //Segue to settings
    @IBAction func goToSettingsButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToSettings", sender: self)
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
                    if let contactID = document.data()["id"] as? String, let contactUsername = document.data()["name"] as? String{
                        let contactEmail = document.documentID
                        let contact = Contact(username: contactUsername, email: contactEmail, id: contactID)
                        
                        self.contacts.append(contact)
                        self.filterContacts()
                        DispatchQueue.main.async {
                            self.contactTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // Filtering the contacts when using the SearchBar
    func filterContacts(){
        filteredContacts = []
        for contact in contacts {
            filteredContacts.append(contact)
        }
        contactTableView.reloadData()
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
        filteredContacts.count
    }
    
    // Creating each TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        let contact = filteredContacts[indexPath.row]
        cell.nameLabel.text = contact.username
        return cell
    }
    
    // Handling a selected TableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

// MARK: SearchBar Functionality
extension ContactsViewController: UISearchBarDelegate {
    
    // Searchbar will always control when it's being interracted with
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredContacts = []
        
        // If the searchbarText contains an empty string the filtered data will only be the contacts array
        if searchText == "" {
            filterContacts()
            
        // Else check if the array has elements that contains the searchbarText and display them as a filtered list
        } else {
            for data in contacts {
                if data.username.lowercased().contains(searchText.lowercased()) {
                    filteredContacts.append(data)
                }
            }
        }
        contactTableView.reloadData()
    }
}
