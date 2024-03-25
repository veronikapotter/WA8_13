//
//  SearchBottomSheetController.swift
//  WA8_13
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import UIKit

class SearchBottomSheetController: UIViewController {

    let searchSheet = SearchBottomSheetView()
    
    //MARK: the list of names...
    //MARK: CHANGE THIS
    var namesDatabase = ["Marvin Cook","Samira Jimenez","Coral Hancock","Xander Wade","Terence Mcneil","Dewey Buckley","Ophelia Higgins","Asiya Anthony","Francesco Knight","Claude Gonzalez","Demi Decker","Casey Park","Jon Hendrix","Hope Harvey","Richie Alexander","Carmen Proctor","Mercedes Callahan","Yahya Gibbs","Julian Pittman","Shauna Ray"]
    
    //MARK: the array to display the table view...
    var namesForTableView = [String]()
    
    override func loadView() {
        view = searchSheet
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: sorting the names list...
        namesDatabase.sort()
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        //MARK: setting up Search Bar delegate...
        searchSheet.searchBar.delegate = self
        
        //MARK: initializing the array for the table view with all the names...
        namesForTableView = namesDatabase
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
            namesForTableView = namesDatabase
        }else{
            self.namesForTableView.removeAll()

            for name in namesDatabase{
                if name.contains(searchText){
                    self.namesForTableView.append(name)
                }
            }
        }
        self.searchSheet.tableViewSearchResults.reloadData()
    }
}
