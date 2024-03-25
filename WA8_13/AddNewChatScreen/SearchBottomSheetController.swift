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
    
    //MARK: the list of names...
    var userDatabase = [User]()
    
    //MARK: the array to display the table view...
    var namesForTableView = [String]()
    
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
                        self.namesForTableView.append(user.name)
                    }
                    
                    self.searchSheet.tableViewSearchResults.reloadData()
                }
        })
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
        
        cell.labelTitle.text = namesForTableView[indexPath.row]
        return cell
    }
}

//MARK: adopting the search bar protocol...
extension SearchBottomSheetController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            for user in userDatabase {
                namesForTableView.append(user.name)
            }
        }else{
            self.namesForTableView.removeAll()

            for user in userDatabase{
                if user.name.contains(searchText){
                    self.namesForTableView.append(user.name)
                }
            }
        }
        self.searchSheet.tableViewSearchResults.reloadData()
    }
}
