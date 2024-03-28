//
//  MessageTableViewCell.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/28/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelUser: UILabel!
    var labelLastMessage: UILabel!
    var labelLastMsgTimestamp: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelUser()
        setupLabelLastMessage()
        setupLabelLastMsgTimestamp()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelUser(){
        labelUser = UILabel()
        labelUser.font = UIFont.boldSystemFont(ofSize: 20)
        labelUser.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelUser)
    }
    
    func setupLabelLastMessage(){
        labelLastMessage = UILabel()
        labelLastMessage.font = UIFont.boldSystemFont(ofSize: 14)
        labelLastMessage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLastMessage)
    }
    
    func setupLabelLastMsgTimestamp(){
        labelLastMsgTimestamp = UILabel()
        labelLastMsgTimestamp.font = UIFont.boldSystemFont(ofSize: 14)
        labelLastMsgTimestamp.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLastMsgTimestamp)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelUser.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelUser.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelUser.heightAnchor.constraint(equalToConstant: 20),
            labelUser.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelLastMessage.topAnchor.constraint(equalTo: labelUser.bottomAnchor, constant: 2),
            labelLastMessage.leadingAnchor.constraint(equalTo: labelUser.leadingAnchor),
            labelLastMessage.heightAnchor.constraint(equalToConstant: 16),
            labelLastMessage.widthAnchor.constraint(lessThanOrEqualTo: labelUser.widthAnchor),
            
            labelLastMsgTimestamp.topAnchor.constraint(equalTo: labelLastMessage.bottomAnchor, constant: 2),
            labelLastMsgTimestamp.leadingAnchor.constraint(equalTo: labelLastMessage.leadingAnchor),
            labelLastMsgTimestamp.heightAnchor.constraint(equalToConstant: 16),
            labelLastMsgTimestamp.widthAnchor.constraint(lessThanOrEqualTo: labelUser.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
