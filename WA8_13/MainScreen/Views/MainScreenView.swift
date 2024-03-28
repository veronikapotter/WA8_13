//
//  MainScreenView.swift
//  WA8_fix
//
//  Created by Bayden Ibrahim on 3/25/24.
//

import UIKit

class MainScreenView: UIView {
    
    var profilePic: UIImageView!
    var labelText: UILabel!
    var floatingButtonNewChat: UIButton!
    var tableViewChats: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        setupFloatingButtonNewChat()
        setupTableViewChats()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal)
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupTableViewChats(){
        tableViewChats = UITableView()
        tableViewChats.register(ChatsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewChatsID)
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChats)
    }
    
    func setupFloatingButtonNewChat(){
        floatingButtonNewChat = UIButton(type: .system)
        floatingButtonNewChat.setTitle("", for: .normal)
        floatingButtonNewChat.setImage(UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        floatingButtonNewChat.contentHorizontalAlignment = .fill
        floatingButtonNewChat.contentVerticalAlignment = .fill
        floatingButtonNewChat.imageView?.contentMode = .scaleAspectFit
        floatingButtonNewChat.layer.cornerRadius = 16
        floatingButtonNewChat.imageView?.layer.shadowOffset = .zero
        floatingButtonNewChat.imageView?.layer.shadowRadius = 0.8
        floatingButtonNewChat.imageView?.layer.shadowOpacity = 0.7
        floatingButtonNewChat.imageView?.clipsToBounds = true
        floatingButtonNewChat.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonNewChat)
    }
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            profilePic.widthAnchor.constraint(equalToConstant: 32),
            profilePic.heightAnchor.constraint(equalToConstant: 32),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelText.topAnchor.constraint(equalTo: profilePic.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8),
            
            tableViewChats.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8),
            tableViewChats.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewChats.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewChats.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            floatingButtonNewChat.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonNewChat.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonNewChat.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButtonNewChat.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

