//
//  ViewController.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/22/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    var chatsList = [Chat]()
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    let database = Firestore.firestore()
    let notificationCenter = NotificationCenter.default
    let searchSheetController = SearchBottomSheetController()
    var searchSheetNavController: UINavigationController!
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see the chats!"
                self.mainScreen.floatingButtonNewChat.isEnabled = false
                self.mainScreen.floatingButtonNewChat.isHidden = true
                
                //MARK: Reset tableView...
                self.chatsList.removeAll()
                self.mainScreen.tableViewChats.reloadData()
                self.setupRightBarButton(isLoggedin: false)
                
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonNewChat.isEnabled = true
                self.mainScreen.floatingButtonNewChat.isHidden = false
                self.setupRightBarButton(isLoggedin: true)
                
                // MARK: handle updating the table view of last messages to various users
                self.database.collection("users")
                    .document(self.currentUser!.email!)
                    .collection("chats")
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                        if let documents = querySnapshot?.documents{
                            self.chatsList.removeAll()
                            for document in documents{
                                do{
                                    let chat  = try document.data(as: Chat.self)
                                    print(chat)
                                    self.chatsList.append(chat)
                                }catch{
                                    print(error)
                                }
                            }
                            self.chatsList.sort(by: {$0.last_msg_timestamp < $1.last_msg_timestamp})
                            self.mainScreen.tableViewChats.reloadData()
                        }
                })
            }
        }
    }
    
    
    func createChat(user: User) {
        // make chat doc in curr user
        // make chat doc in user
        // make chat doc in chats collection
        let timestamp = NSDate().timeIntervalSince1970
        let check = currentUser
        let userNames = [user.name, currentUser!.displayName!]
        var chat = Chat(userNames: userNames, last_msg: "", last_msg_timestamp: timestamp)
        var chatID: String = ""
        if currentUser!.email! < user.email {
            chatID = currentUser!.email!+user.email
        } else {
            chatID = user.email+currentUser!.email!
        }
        
        database.collection("users").document(user.email.lowercased())
            do{
                // add to current user
                try database
                    .collection("users")
                    .document(currentUser!.email!.lowercased())
                    .collection("chats")
                    .document(chatID)
                    .setData(["userNames": userNames], merge: true, completion: {(error) in
                    if error == nil{
                        print("User added to currUser db.")
                    }
                    })
                
                // add to chatting user
                try database
                    .collection("users")
                    .document(user.email.lowercased())
                    .collection("chats")
                    .document(chatID)
                    .setData(["userNames": userNames], merge: true, completion: {(error) in
                    if error == nil{
                        print("User added to chatting user db.")
                    }
                })
                
                // add to chat
                try database
                    .collection("chats")
                    .document(chatID)
                    .setData(["userNames": userNames], merge: true, completion: {(error) in
                    if error == nil{
                        print("User added to chat db.")
                    }
                })
                
                let chatScreenController = ChatViewController()
                chatScreenController.currentChatID = chatID
                chatScreenController.currentChatPartner = user.name
                chatScreenController.currentUser = currentUser
                navigationController?.pushViewController(chatScreenController, animated: true)
            }catch{
                print("Error adding all documents!")
            }
        }
    // MARK: func to get the details of a particualr chat between two users
    func getChatDetails(currChat: Chat) {
        if let user = currentUser {
            if let email = user.email {
                let docRef = database.collection("chats")
                    .document(currChat.id!)
                
                docRef.getDocument(as: Chat.self) { result in
                    switch result {
                    case .success(let chat):
                        // A Book value was successfully initialized from the DocumentSnapshot.
                        //getChatDetails(chat: chat)
                        print("HEY HEY \(chat.id)" )
                        let chatViewController = ChatViewController()
                        chatViewController.currentChatID = currChat.id
                        
                        if currChat.userNames[0] == user.displayName {
                            chatViewController.currentChatPartner = currChat.userNames[1]
                        } else {
                            chatViewController.currentChatPartner = currChat.userNames[1]
                        }
                        
                        if currChat.userEmails[0] == user.email {
                            chatViewController.currentChatPartnerEmail = currChat.userEmails[1]
                        } else {
                            chatViewController.currentChatPartnerEmail = currChat.userEmails[1]
                        }
                        
                        chatViewController.currentUser = user
                        self.navigationController?.pushViewController(chatViewController, animated: true)
                    case .failure(let error):
                        // A Book value could not be initialized from the DocumentSnapshot.
                        print("No chat exists. \(user.email)")
                    }
            }
            
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        
        mainScreen.tableViewChats.delegate = self
        mainScreen.tableViewChats.dataSource = self
        
        mainScreen.tableViewChats.separatorStyle = .none
        
        //MARK: Make the titles look large...
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: Put the floating button above all the views...
        view.bringSubviewToFront(mainScreen.floatingButtonNewChat)
        
        mainScreen.floatingButtonNewChat.addTarget(self, action: #selector(onNewChatButtonTapped), for: .touchUpInside)
        
        observeNameSelected()
        
    }
    
    func observeNameSelected(){
        // MARK: fix this
//        notificationCenter.addObserver(
//            self,
//            selector: #selector(onNameSelected(notification:)),
//            name: .nameSelected, object: nil)
    }
    @objc func onNameSelected(notification: Notification){
        if let selectedName = notification.object{
            // MARK: do something here idk what yet
            //mainScreen.labelName.text = selectedName as! String
        }
    }
    
    @objc func onNewChatButtonTapped(){
        setupSearchBottomSheet()
        present(searchSheetNavController, animated: true)
    }
    
    
    func setupSearchBottomSheet(){
        //MARK: setting up bottom search sheet...
        searchSheetNavController = UINavigationController(rootViewController: searchSheetController)
        
        // MARK: setting up modal style...
        searchSheetNavController.modalPresentationStyle = .pageSheet
        searchSheetController.currentUser = currentUser //pass the email of the currect user 
        
        if let bottomSearchSheet = searchSheetNavController.sheetPresentationController{
            bottomSearchSheet.detents = [.medium(), .large()]
            bottomSearchSheet.prefersGrabberVisible = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    
    
}

