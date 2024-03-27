//
//  Message.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Codable{
    @DocumentID var id: String?
    var user: String
    var text: String
    var timestamp: Double
    
    init(user: String, text: String, timestamp: Double) {
        self.user = user
        self.text = text
        self.timestamp = timestamp
    }
}
