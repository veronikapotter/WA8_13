//
//  User.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var chats: [Chat]
    
    init(name: String, email: String, chats: [Chat]) {
        self.name = name
        self.email = email
        self.chats = chats
    }
}
