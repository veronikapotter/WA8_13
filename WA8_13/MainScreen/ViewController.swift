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
                                    self.chatsList.append(chat)
                                }catch{
                                    print(error)
                                }
                            }
                            self.chatsList.sort(by: {$0.last_msg_timestamp > $1.last_msg_timestamp})
                            self.mainScreen.tableViewChats.reloadData()
                        }
                    })
            }
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
                        let chatViewController = ChatViewController()
                        chatViewController.currentChatID = currChat.id
                        
                        if currChat.userNames[0] == user.displayName {
                            chatViewController.currentChatPartner = currChat.userNames[1]
                        } else {
                            chatViewController.currentChatPartner = currChat.userNames[0]
                        }
                        
                        if currChat.userEmails[0] == user.email {
                            chatViewController.currentChatPartnerEmail = currChat.userEmails[1]
                        } else {
                            chatViewController.currentChatPartnerEmail = currChat.userEmails[0]
                        }
                        
                        chatViewController.currentUser = user
                        self.navigationController?.pushViewController(chatViewController, animated: true)
                    case .failure(let error):
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

        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
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
        searchSheetController.mainNavController = self.navigationController
        
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

