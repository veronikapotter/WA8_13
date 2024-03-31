//
//  SearchBottomSheetController.swift
//  WA8_13
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SearchBottomSheetController: UIViewController {
    
    let searchSheet = SearchBottomSheetView()
    let database = Firestore.firestore()
    var currentUser: FirebaseAuth.User!
    
    //MARK: the list of users
    var userDatabase = [User]()
    
    //MARK: the array to display the table view
    // we are using users so we may easily get the respective emails.
    var namesForTableView = [User]()
    
    override func loadView() {
        view = searchSheet
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        //MARK: setting up Search Bar delegate...
        searchSheet.searchBar.delegate = self
        
        getallusers()
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    // MARK: request to firebase "users" collection to get all the users to chat with
    func getallusers(){
        // MARK: handle updating the table view of last messages to various users
        self.database.collection("users")
            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                if let documents = querySnapshot?.documents{
                    self.userDatabase.removeAll()
                    self.namesForTableView.removeAll()
                    for document in documents{
                        do{
                            let user  = try document.data(as: User.self)
                            // MARK: exclude the current user from chatting with themselves.
                            if let userEmail = self.currentUser.email {
                                if user.email.lowercased() != userEmail {
                                    self.userDatabase.append(user)
                                }
                            }
                        }catch{
                            print(error)
                        }
                    }
                    for user in self.userDatabase {
                        self.namesForTableView.append(user)
                    }
                    
                    // MARK: update the search tableView with the users
                    self.userDatabase.sort(by: {$0.name < $1.name})
                    self.searchSheet.tableViewSearchResults.reloadData()
                }
            })
    }
    
    func createChat(user: User) {
        // make chat doc in curr user
        // make chat doc in user
        // make chat doc in chats collection
        if let currUser = currentUser {
            let timestamp = NSDate().timeIntervalSince1970
            let userNames = [user.name, currentUser.displayName!]
            let userEmails = [user.email, currentUser.email!]
            var chat = Chat(userNames: userNames, userEmails: userEmails, last_msg: "", last_msg_timestamp: 0)
            var chatID: String = ""
            if currentUser.email! < user.email {
                chatID = (currentUser.email!+user.email).lowercased()
            } else {
                chatID = (user.email+currentUser.email!).lowercased()
            }
            
            if let email = currUser.email {
                let docRef = database.collection("chats")
                    .document(chatID)
                
                docRef.getDocument(as: Chat.self) { result in
                    switch result {
                    case .success(let chat):
                        let chatScreenController = ChatViewController()
                        chatScreenController.currentChatID = chatID
                        chatScreenController.currentChatPartner = user.name
                        chatScreenController.currentUser = currUser
                        chatScreenController.currentChatPartnerEmail = user.email
                        self.navigationController?.pushViewController(chatScreenController, animated: true)
                    case .failure(let error):
                        do{
                            // add to current user
                            try self.database
                                .collection("users")
                                .document(currUser.email!.lowercased())
                                .collection("chats")
                                .document(chatID)
                                .setData(from: chat, merge: true, completion: {(error) in
                                    if error == nil{
                                        print("User added to currUser db.")
                                    }
                                })
                            
                            // add to chatting user
                            try self.database
                                .collection("users")
                                .document(user.email.lowercased())
                                .collection("chats")
                                .document(chatID)
                                .setData(from: chat, merge: true, completion: {(error) in
                                    if error == nil{
                                        print("User added to chatting user db.")
                                    }
                                })
                            
                            // add to chat
                            try self.database
                                .collection("chats")
                                .document(chatID)
                                .setData(from: chat, merge: true, completion: {(error) in
                                    if error == nil{
                                        print("User added to chat db.")
                                    }
                                })
                            
                            let chatScreenController = ChatViewController()
                            chatScreenController.currentChatID = chatID
                            chatScreenController.currentChatPartner = user.name
                            chatScreenController.currentUser = currUser
                            chatScreenController.currentChatPartnerEmail = user.email
                            self.navigationController?.pushViewController(chatScreenController, animated: true)
                        }catch{
                            print("Error adding all documents!")
                        }
                    }
                }
            }
        }
    }
}

//MARK: adopting Table View protocols...
extension SearchBottomSheetController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Configs.searchTableViewID, for: indexPath) as! SearchTableCell
        cell.labelTitle.text = namesForTableView[indexPath.row].name
        return cell
    }
    
    // MARK: handle navigating to a new chat when the username is pressed.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        createChat(user: namesForTableView[indexPath.row])
        
        self.dismiss(animated: true)
    }
    
}

//MARK: adopting the search bar protocol...
extension SearchBottomSheetController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.namesForTableView.removeAll()
        if searchText == ""{
            for user in userDatabase {
                namesForTableView.append(user)
            }
        }else{
            for user in userDatabase{
                if user.name.contains(searchText){
                    self.namesForTableView.append(user)
                }
            }
        }
        self.searchSheet.tableViewSearchResults.reloadData()
    }
}
