//
//  RegisterFirebaseManager.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

extension RegisterViewController{
    
    func registerNewAccount(){
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{

            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    let user = User(name: name, email: email)
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    self.addUserToDatabase(user: user)
                }else{
                    //MARK: there is a error creating the user...
                    print(error)
                }
            })
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
    
    //MARK: We set the name of the user after we create the account...
    func addUserToDatabase(user: User){
        // create doc reference
        let collectionUsersDoc = database.collection("users").document(user.email.lowercased())
        do{
            try collectionUsersDoc.setData(from: user, completion: {(error) in
                if error == nil{
                    print("User added to db.")
                }
            })
        }catch{
            print("Error adding document!")
        }
    }
}

