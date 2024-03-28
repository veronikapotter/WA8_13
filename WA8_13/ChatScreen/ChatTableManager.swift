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
        cell.labelLastMsgTimestamp.text = "\(messageList[indexPath.row].timestamp)"
        return cell
    }
}

