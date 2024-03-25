//
//  ChatViewController.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/25/24.
//
/*
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    let chatScreen = ChatView()
    var currentChat: Chat!
    let database = Firestore.firestore()
    var messageList = [Message]()
    
    override func loadView() {
        view = chatScreen
    }

    override func viewDidLoad() {
        title = "\(currentChat.user)"
        
        super.viewDidLoad()
        
        // MARK: add observer for when the chat updates
        // TODO: need to sort through current user. Need to set up tableview.
        self.database.collection("chats")
            .document((self.currentChat?.user.name)!)
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
                self.mainScreen.tableViewContacts.reloadData()
            }
        })

        // Do any additional setup after loading the view.
    }
}*/
