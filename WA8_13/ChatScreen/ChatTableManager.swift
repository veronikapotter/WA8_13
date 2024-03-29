//
//  ChatTableManager.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/25/24.
//

import Foundation

import UIKit

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessagesID, for: indexPath) as! ChatsTableViewCell
        cell.labelUser.text = messageList[indexPath.row].user
        cell.labelLastMessage.text = messageList[indexPath.row].text
        
        let date = Date(timeIntervalSince1970: messageList[indexPath.row].timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d 'at' h:mm a"
        let dateString = formatter.string(from: date)
        cell.labelLastMsgTimestamp.text = dateString
        
        
        if cell.labelUser.text == currentUser?.displayName {
            cell.labelUser.textAlignment = .natural
            cell.labelLastMessage.textAlignment = .natural
            cell.labelLastMsgTimestamp.textAlignment = .natural
            cell.labelUser.textAlignment = .right
            cell.labelUser.textColor = .white
            cell.labelLastMessage.textAlignment = .right
            cell.labelLastMessage.textColor = .white
            cell.labelLastMsgTimestamp.textAlignment = .right
            cell.labelLastMsgTimestamp.textColor = .white
            cell.wrapperCellView.backgroundColor = UIColor.systemBlue
        } else {
            cell.wrapperCellView.backgroundColor = UIColor.systemGray6
        }
        
        return cell
    }
    
}

