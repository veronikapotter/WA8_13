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
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        //MARK: setting up Search Bar delegate...
        searchSheet.searchBar.delegate = self
        
        getallusers()
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
                    // MARK: update the search tableView with the users
                    self.userDatabase.sort(by: {$0.name < $1.name})
                    for user in self.userDatabase {
                        self.namesForTableView.append(user)
                    }
                    
                    self.searchSheet.tableViewSearchResults.reloadData()
                }
        })
    }
    
    // MARK: either creates a new chat between two users or loads the existing chat
    func createChat(user: User) {
        if let email = currentUser.email {
            let docRef = database.collection("users")
                .document(email)
                .collection("chats")
                .document(user.email)
              
              docRef.getDocument(as: Chat.self) { result in
                switch result {
                case .success(let chat):
                  // A Book value was successfully initialized from the DocumentSnapshot.
                  //getChatDetails(chat: chat)
                  print("HEY HEY")
                case .failure(let error):
                  // A Book value could not be initialized from the DocumentSnapshot.
                  print("No chat exists.")
                  var chat = Chat(user: user, last_msg: "", last_msg_timestamp: 0, messages: [Message]())
                  let doc = self.database.collection("users")
                        .document(email)
                        .collection("chats").document(user.email)
                  do{
                      try doc.setData(from: chat, completion: {(error) in
                        if error == nil{
                            print("chat added to db")
                        }
                      })
                  }catch{
                    print("Error adding document!")
                  }
                }
              }
            
            
            /*
            self.database.collection("users")
                .document(email)
                .collection("chats")
            
            
            
                .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                    if let documents = querySnapshot?.documents{
                        for document in documents{
                            do{
                                let chat  = try document.data(as: Chat.self)
                                // MARK: exclude the current user from chatting with themselves.
                                if user.email == chat.id {
                                    //getChatDetails(chat: chat)
                                }
                            }catch{
                                print(error)
                            }
                        }
                        
                            var chat = Chat(id: email, user: user, last_msg: "", last_msg_timestamp: 0, messages: [Message]())
                            let collectionChats = self.database.collection("users")
                                .document(email)
                                .collection("chats")
                            do{
                                try collectionChats.addDocument(from: chat, completion: {(error) in
                                    if error == nil{
                                        print("chat added to db")
                                    }
                                })
                            }catch{
                                print("Error adding document!")
                            }
                        
                    }
                })*/
            }
        }
    
        
            
            
            //.collection("chats").document(user.email)


        
        
        
        // API request to create a new chat if one does not exist.
        
        
        // API request to users -> chats -> messages.
        /*let chatViewController = ChatViewController()
         chatViewController.currentChat = chat
         navigationController?.pushViewController(chatViewController, animated: <#T##Bool#>)*/
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click click")
        createChat(user: namesForTableView[indexPath.row])
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
