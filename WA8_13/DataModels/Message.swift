//
//  Message.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Codable{
    @DocumentID var id: String?
    var user: User // user is the user that sent the message
    var text: String
    var timestamp: Int
    
    init(user: User, text: String, timestamp: Int) {
        self.user = user
        self.text = text
        self.timestamp = timestamp
    }
}
