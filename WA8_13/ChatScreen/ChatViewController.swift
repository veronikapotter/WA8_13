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
    var currentChatID: String?
    var currentChatPartner: String?
    var currentChatPartnerEmail: String?
    var currentUser: FirebaseAuth.User!
    let database = Firestore.firestore()
    var messageList = [Message]()
    
    override func loadView() {
        view = chatScreen
    }
    
    override func viewDidLoad() {
        title = "\(currentChatPartner!)"
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        chatScreen.tableViewMessages.delegate = self
        chatScreen.tableViewMessages.dataSource = self
        
        chatScreen.tableViewMessages.separatorStyle = .none
        
        chatScreen.buttonSend.addTarget(self, action: #selector(onButtonSendTapped), for: .touchUpInside)
        
        // MARK: add observer for when the chat updates. UPDATE TO LOOK IN THE CHAT LIST.
        database.collection("chats")
            .document((currentChatID)!)
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
                    self.messageList.sort(by: {$0.timestamp < $1.timestamp})
                    self.chatScreen.tableViewMessages.reloadData()
                    self.scrollToBottom()
                }
            })
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            chatScreen.adjustForKeyboard(height: keyboardHeight)
        }
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    func scrollToBottom() {
        let numberOfSections = chatScreen
            .tableViewMessages
            .numberOfSections
        let numberOfRows = chatScreen
            .tableViewMessages.numberOfRows(
                inSection: numberOfSections - 1)
        if numberOfRows > 0 {
            let indexPath = IndexPath(
                row: numberOfRows - 1,
                section: numberOfSections - 1)
            chatScreen.tableViewMessages
                .scrollToRow(at: indexPath,
                             at: .bottom, animated: true)
        }
    }
    
    // MARK: handle sending messge
    @objc func onButtonSendTapped(){
        if let user = currentUser, let email = user.email, let name = user.displayName, let partnerEmail = currentChatPartnerEmail, let chatID = currentChatID {
            var text = chatScreen.textMessage.text
            if let message = text {
                let timestamp = NSDate().timeIntervalSince1970
                let newMessage = Message(user: name, text: message, timestamp: timestamp)
                // TODO: send this message to all 3 databases so that they update accordingly. Chats should have the message, the users dbs should have updated last timestamp and last_message
                do{
                    // add to current user
                    try self.database
                        .collection("users")
                        .document(user.email!.lowercased())
                        .collection("chats")
                        .document(chatID)
                        .setData(["last_msg": message, "last_msg_timestamp": timestamp], merge: true, completion: {(error) in
                            if error == nil{
                                print("Message added to currUser db.")
                            }
                        })
                    
                    // add to chatting user
                    try self.database
                        .collection("users")
                        .document(partnerEmail.lowercased())
                        .collection("chats")
                        .document(chatID)
                        .setData(["last_msg": message, "last_msg_timestamp": timestamp], merge: true, completion: {(error) in
                            if error == nil{
                                print("Message added to chatting user db.")
                            }
                        })
                    
                    // add to chat
                    try self.database
                        .collection("chats")
                        .document(chatID)
                        .collection("messages")
                        .addDocument(from: newMessage, completion: {(error) in
                            if error == nil{
                                print("User added to chat db.")
                            }
                        })
                    try self.database
                        .collection("chats")
                        .document(chatID)
                        .setData(["last_msg": message, "last_msg_timestamp": timestamp], merge: true, completion: {(error) in
                            if error == nil{
                                print("User added to chat db.")
                            }
                        })
                }catch{
                    print("Error adding all documents!")
                }
                
                chatScreen.textMessage.text = ""
            }
            
        }
        
    }
}
