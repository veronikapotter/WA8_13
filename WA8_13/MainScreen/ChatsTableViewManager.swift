//
//  ChatsTableViewManager.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import Foundation

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewChatsID, for: indexPath) as! ChatsTableViewCell
        cell.labelUser.text = chatsList[indexPath.row].user.name
        cell.labelLastMessage.text = chatsList[indexPath.row].last_msg
        cell.labelLastMsgTimestamp.text = "\(chatsList[indexPath.row].last_msg_timestamp)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getChatDetails(chat: self.chatsList[indexPath.row])
    }
}
