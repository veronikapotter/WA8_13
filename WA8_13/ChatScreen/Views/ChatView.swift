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
    var textMessageBottomConstraint: NSLayoutConstraint?
    var buttonSendBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupTableViewMessages()
        setupButtonSend()
        setupTextMessage()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupTableViewMessages(){
        tableViewMessages = UITableView()
        tableViewMessages.register(ChatsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMessagesID)
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(tableViewMessages)
    }
    
    func setupButtonSend() {
        buttonSend = UIButton(type: .system)
        buttonSend.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonSend)
    }
    
    func setupTextMessage() {
        textMessage = UITextField()
        textMessage.placeholder = "Text Message"
        textMessage.borderStyle = .roundedRect
        textMessage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textMessage)
    }
    
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        textMessageBottomConstraint = textMessage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        buttonSendBottomConstraint = buttonSend.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        
        
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            contentWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            contentWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            contentWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            tableViewMessages.topAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewMessages.bottomAnchor.constraint(equalTo: buttonSend.topAnchor, constant: -32),
            tableViewMessages.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewMessages.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonSendBottomConstraint!,
            buttonSend.bottomAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            buttonSend.leadingAnchor.constraint(equalTo: textMessage.trailingAnchor, constant: 4),
            buttonSend.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            textMessageBottomConstraint!,
            textMessage.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            textMessage.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -4),
            
            
        ])
        
    }
    
    // source: Gagana
    func adjustForKeyboard(height: CGFloat) {
        textMessageBottomConstraint?.constant = -height + 25
        buttonSendBottomConstraint?.constant = -height + 25
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } }
    
}
