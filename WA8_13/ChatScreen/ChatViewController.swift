//
//  ChatViewController.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/25/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    let chatScreen = ChatView()
    var currentChat: Chat!
    var currentUser: FirebaseAuth.User!
    let database = Firestore.firestore()
    var messageList = [Message]()
    
    override func loadView() {
        view = chatScreen
    }

    override func viewDidLoad() {
        title = "\(currentChat.user.name)"
        print(currentChat)
        
        super.viewDidLoad()
        
        chatScreen.buttonSend.addTarget(self, action: #selector(onButtonSendTapped), for: .touchUpInside)
        
        // MARK: add observer for when the chat updates
        self.database.collection("users")
            .document((self.currentUser.email)!)
            .collection("chats")
            .document((self.currentChat.id)!)
            .collection("messages")
            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                if let documents = querySnapshot?.documents{
                    self.messageList.removeAll()
                    for document in documents{
                    do{
                        let message  = try document.data(as: Message.self)
                        self.messageList.append(message)
                        }catch{
                            print(error)
                        }
                    }
                self.messageList.sort(by: {$0.timestamp > $1.timestamp})
                self.chatScreen.tableViewMessages.reloadData()
            }
        })
    }
    
    // MARK: handle sending messge
    @objc func onButtonSendTapped(){
        if let user = currentUser, let email = user.email, let name = user.displayName {
            var text = chatScreen.textMessage.text
            if let message = text {
                let timestamp = NSDate().timeIntervalSince1970
                let newMessage = Message(user: name, text: message, timestamp: timestamp)
                let messages = database
                    .collection("users")
                    .document(email)
                    .collection("chats")
                    .document(self.currentChat.id!)
                do{
                    try messages.setData(from: newMessage, completion: {(error) in
                        if error == nil{
                            print("Message added to db")
                            print(newMessage)
                            print(email)
                            print(self.currentChat.id!)
                            print(self.currentChat)
                        }
                    })
                }catch{
                    print("Error adding document!")
                }
                    
                    
                }
                
            }
    
    }
}
