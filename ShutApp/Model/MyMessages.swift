//
//  MyMessages.swift
//  ShutApp
//
//  Created by Erik Ugarte on 2020-12-14.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import Foundation
import Firebase

class MyMessages {
    let db = Firestore.firestore()
    let currentUser = CurrentUser()
    let currentUserSender = Sender(senderEmail: CurrentUser().email, displayName: CurrentUser().username)
    var messages = [Message]()
    
    // Loading the messages from the database
    func getMessagesFromDatabase(collectionView: UICollectionView, senderUser: Sender) {
        messages = []
        let collection = db.collection("users").document(currentUser.email).collection("contacts").document(senderUser.senderEmail).collection("messages")
        
        // Reading from the "messages" Collection and ordering them by date
        collection.order(by: "date").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let messageBody = document.data()["body"] as? String, let messageSender = document.data()["sender"] as? String, let messageDate = document.data()["date"] as? Double{
                        // If the retrieved message has currentUser as sender create a rightside Message
                        if messageSender == self.currentUser.email {
                            self.messages.append(Message(sender: self.currentUserSender, messageId: document.documentID, sentDate: Date().addingTimeInterval(messageDate), kind: .text(messageBody)))
                            
                        // Else create a leftside Message
                        } else {
                            self.messages.append(Message(sender: senderUser, messageId: document.documentID, sentDate: Date().addingTimeInterval(messageDate), kind: .text(messageBody)))
                        }
                        // Reload the MessageCollectionView
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

