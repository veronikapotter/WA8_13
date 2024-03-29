//
//  ChatView.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/25/24.
//
import UIKit

class ChatView: UIView {
    
    // TODO: add scroll view
    var contentWrapper: UIScrollView!
    var tableViewMessages: UITableView!
    var bottomSendMessageView: UIView!
    var textMessage: UITextField!
    var buttonSend: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewMessages()
        setupButtonSend()
        setupTextMessage()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableViewMessages(){
        tableViewMessages = UITableView()
        tableViewMessages.register(ChatsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMessagesID)
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMessages)
    }
    
    func setupButtonSend() {
        buttonSend = UIButton(type: .system)
        buttonSend.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSend)
    }
    
    func setupTextMessage() {
        textMessage = UITextField()
        textMessage.placeholder = "Aa"
        textMessage.borderStyle = .roundedRect
        textMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textMessage)
    }
    
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            tableViewMessages.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewMessages.bottomAnchor.constraint(equalTo: buttonSend.topAnchor, constant: -32),
            tableViewMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonSend.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            buttonSend.leadingAnchor.constraint(equalTo: textMessage.trailingAnchor, constant: 4),
            buttonSend.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            textMessage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            textMessage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            textMessage.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -4),
            
        ])
        
    }
    
}
