//
//  Chat.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Codable{
    @DocumentID var id: String?
    var user: User
    var last_msg: String
    var last_msg_timestamp: Int
    var messages: [Message]
    
    init(user: User, last_msg: String, last_msg_timestamp: Int, messages: [Message]) {
        self.user = user
        self.last_msg = last_msg
        self.last_msg_timestamp = last_msg_timestamp
        self.messages = messages
    }
}
