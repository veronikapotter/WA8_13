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
    var userNames: [String]
    var userEmails: [String]
    var last_msg: String
    var last_msg_timestamp: Double
    
    init(userNames: [String] = [], userEmails: [String] = [], last_msg: String = "Aa", last_msg_timestamp: Double = 0) {
        self.userNames = userNames
        self.userEmails = userEmails
        self.last_msg = last_msg
        self.last_msg_timestamp = last_msg_timestamp
    }
}
