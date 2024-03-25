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
                    .document((self.currentUser?.email)!)
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
                            self.chatsList.sort(by: {$0.last_msg_timestamp < $1.last_msg_timestamp})
                            self.mainScreen.tableViewChats.reloadData()
                        }
                    })
            }
        }
    }
    
    // MARK: func to get the details of a particualr chat between two users
    func getChatDetails(chat: Chat) {
        // API request to users -> chats -> messages.
        /*let chatViewController = ChatViewController()
         chatViewController.currentChat = chat
         navigationController?.pushViewController(chatViewController, animated: <#T##Bool#>)*/
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

