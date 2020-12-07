//
//  ChatViewController.swift
//  ShutApp
//
//  Created by Alexander Jansson on 2020-12-07.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import UIKit
import MessageKit
import Firebase


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    let id = Auth.auth().currentUser!.uid
    
 
    let currentUser = Sender(senderId: "self", displayName: "HEJ")
    var messages = [Message]()

    func currentSender () -> SenderType  {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType{
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messages.append(Message(sender: currentUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("Hello Dude")))
    }
    
    
    
    
}
