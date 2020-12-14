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
    var chatContact = Contact(username: "", email: "", id: "")

    
    let currentUser = Sender(senderId: "self", displayName: "HEJ")
    let secoundUser = Sender(senderId: "test", displayName: "HEJSAN")
    var messages = [Message]()

    func currentSender () -> SenderType  {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType{
        return messages[indexPath.section]
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
           return .white
       }
    
    
    func sendButtonItemBar () {
        messageInputBar.sendButton.configure {
                   $0.setSize(CGSize(width: 370, height: 36), animated: false)
                   $0.isEnabled = false
                   $0.title = ""
                   $0.image = UIImage(named: "baseline_send_black_18dp")
                   $0.tintColor = UIColor.blue
                   $0.setTitleColor(UIColor.purple, for: .normal)
                   $0.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .disabled)
                   $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
               }
    }
    func sendItemBar () {

        self.messageInputBar.inputTextView.placeholder = " Aa"
        self.messageInputBar.inputTextView.textColor = UIColor.white
        self.messageInputBar.inputTextView.beginFloatingCursor(at: CGPoint(x:20,y:20))
        self.messageInputBar.inputTextView.tintColor = UIColor.systemPurple
        self.messageInputBar.inputTextView.placeholderTextColor = UIColor(white: 1, alpha: 0.5)
        self.messageInputBar.inputTextView.backgroundColor = UIColor.lightGray
        self.messageInputBar.inputTextView.layer.cornerRadius = 20
        self.messageInputBar.inputTextView.layer.borderWidth = 2.0
        self.messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.messageInputBar.backgroundView.layer.backgroundColor = UIColor.white.cgColor
        self.messageInputBar.layer.masksToBounds = true
        self.messagesCollectionView.backgroundColor = UIColor.white
        self.messageInputBar.backgroundView.layer.borderColor = UIColor.white.cgColor
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? UIColor.purple : UIColor.lightGray
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
        messages.append(Message(sender: secoundUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("hej Alex")))
        messages.append(Message(sender: currentUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("Hello Dude")))
        messages.append(Message(sender: secoundUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("hej Alex")))
        messages.append(Message(sender: currentUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("Hello Dude")))
        messages.append(Message(sender: secoundUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("hej Alex")))
        messages.append(Message(sender: currentUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("Hello Dude")))
        messages.append(Message(sender: secoundUser, messageId: "1234", sentDate: Date().addingTimeInterval(-10000), kind: .text("hej Alex")))
        sendItemBar ()
        sendButtonItemBar ()
        print(chatContact)
        
    }
    
}
